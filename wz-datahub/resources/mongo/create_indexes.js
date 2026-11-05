// Create indexes on all collections

/*
This is the second script responsible for configuring mongoDB automatically on startup.
This script is responsible for creating users, creating collections, adding indexes, and configuring TTLs
For more information see the header in a_init_replicas.js
*/

console.log("");
console.log("Running create_indexes.js");

Object.keys(process.env).forEach((key) => {
  console.log(`${key}: ${process.env[key]}`);
});

// Setup Username and Password Definitions
const MONGO_ROOT_USERNAME = process.env["MONGO_ADMIN_DB_USER"];
const MONGO_ROOT_PASSWORD = process.env["MONGO_ADMIN_DB_PASS"];

const MONGO_READ_WRITE_USER = process.env["MONGO_READ_WRITE_USER"];
const MONGO_READ_WRITE_PASS = process.env["MONGO_READ_WRITE_PASS"];

const MONGO_READ_USER = process.env["MONGO_READ_USER"];
const MONGO_READ_PASS = process.env["MONGO_READ_PASS"];

// Prometheus Exporter User
const MONGO_EXPORTER_USERNAME = process.env["MONGO_EXPORTER_USERNAME"];
const MONGO_EXPORTER_PASSWORD = process.env["MONGO_EXPORTER_PASSWORD"];

const MONGO_DB_NAME = process.env["MONGO_DB_NAME"] || "datahub";

const users = [
  // {username: CM_MONGO_ROOT_USERNAME, password: CM_MONGO_ROOT_PASSWORD, roles: "root", database: "admin" },
  {
    username: MONGO_READ_WRITE_USER,
    password: MONGO_READ_WRITE_PASS,
    permissions: [{ role: "readWrite", database: MONGO_DB_NAME }],
  },
  {
    username: MONGO_READ_USER,
    password: MONGO_READ_PASS,
    permissions: [{ role: "read", database: MONGO_DB_NAME }],
  },
  {
    username: MONGO_EXPORTER_USERNAME,
    password: MONGO_EXPORTER_PASSWORD,
    permissions: [
      { role: "clusterMonitor", database: "admin" },
      { role: "read", database: MONGO_DB_NAME },
    ],
  },
];

console.log("\n\n\n\nMONGO_READ_WRITE_USER: " + MONGO_READ_WRITE_USER);
console.log("MONGO_READ_WRITE_PASS: " + MONGO_READ_WRITE_PASS + "\n\n\n\n");

// Naming convention:
// topic.*a*.*b*
// - direct from a kafka topic
// - a = data source (e.g., conadmin, datahub)
// - b = data type (e.g., project, work_zone, field_device, raw_vehicle_location)
// raw.*a*
// - raw, un-processed data from a data source
// - a = data source (e.g., ver_mac, pi_lit, worker_locations)
// *a*
// - collections for storing datahub data
const dataHubCollections = [
  {
    name: "topic.conadmin.project",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "topic.conadmin.work_zone",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "topic.conadmin.field_device",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "topic.datahub.work_zone",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "topic.datahub.raw_vehicle_location",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "field_device_links",
    indexes: [{ key: "last_updated", direction: -1 }],
  },
  {
    name: "field_device_readings",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "reports",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "recordings",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "projects",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "road_events",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "road_event_audits",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "raw.icone",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "raw.ver_mac",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "raw.pi_lit",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
  {
    name: "raw.worker_locations",
    indexes: [{ key: "timestamp", direction: -1 }],
  },
];

let collections = [];

collections = collections.concat(dataHubCollections);

try {
  db.getMongo().setReadPref("primaryPreferred");
  db = db.getSiblingDB("admin");
  db.runCommand({ autoCompact: true });

  // Create Users in Database
  for (user of users) {
    createUser(user);
  }

  db = db.getSiblingDB(MONGO_DB_NAME);
  db.getMongo().setReadPref("primaryPreferred");
  var isMaster = db.isMaster();
  if (isMaster.primary) {
    console.log("Connected to the primary replica set member.");
  } else {
    console.log(
      "Not connected to the primary replica set member. Current node: " +
        isMaster.host
    );
  }
} catch (err) {
  console.log("Could not switch DB to Sibling DB");
  console.log(err);
}

// Wait for the collections to exist in mongo before trying to create indexes on them
let missing_collection_count;
do {
  try {
    missing_collection_count = 0;
    const collectionNames = db.getCollectionNames();
    for (collection of collections) {
      // Create Collection if it doesn't exist
      let created = false;
      if (!collectionNames.includes(collection["name"])) {
        created = createCollection(collection);
      } else {
        created = true;
      }

      if (created) {
        createIndexes(collection);
      } else {
        missing_collection_count++;
        console.log("Collection " + collection["name"] + " does not exist yet");
      }
    }
    if (missing_collection_count > 0) {
      console.log(
        "Waiting on " +
          missing_collection_count +
          " collections to be created...will try again in " +
          retryMilliseconds +
          " ms"
      );
      sleep(retryMilliseconds);
    }
  } catch (err) {
    console.log("Error while setting up indexes in collections");
    console.log(rs.status());
    console.error(err);
    sleep(retryMilliseconds);
  }
} while (missing_collection_count > 0);

function createUser(user) {
  try {
    console.log(
      "Creating User: " +
        user["username"] +
        " with Permissions: " +
        JSON.stringify(user["permissions"])
    );
    db.createUser({
      user: user["username"],
      pwd: user["password"],
      roles: user["permissions"].map((permission) => ({
        role: permission["role"],
        db: permission["database"],
      })),
    });
  } catch (error) {
    console.error("Error creating user: ", error);
  }
}

function createCollection(collection) {
  try {
    db.createCollection(collection["name"]);
    return true;
  } catch (err) {
    console.log("Unable to Create Collection: " + collection.name);
    console.log(err);
    return false;
  }
}

function createIndexes(collection) {
  const indexes = collection["indexes"];
  for (index of indexes) {
    if (indexExists(index)) {
      // Skip if Index already Exists
      continue;
    }
    const collectionName = collection["name"];
    const indexName = index["name"];
    console.log("Creating Index for " + collectionName);

    try {
      db[collectionName].createIndex({ [index.key]: index.direction });
      console.log("Created Index for " + collectionName + ": " + indexName);
    } catch (err) {
      console.log(
        "Unable to Create Index: " + collectionName + ": " + indexName
      );
      console.log(err);
    }
  }
  if (indexExists(collection)) {
    // Skip if Index already Exists
    return;
  }
}

function indexExists(index) {
  return (
    db[collection["name"]]
      .getIndexes()
      .find((idx) => idx.name == index.key + "_" + index.direction) !==
    undefined
  );
}
