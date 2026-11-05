# Use the official Keycloak image as the base
FROM quay.io/keycloak/keycloak:23.0.7

# Set environment variables for Keycloak admin user and password
# These can be overridden at runtime
ENV KEYCLOAK_ADMIN=KEYCLOAK_ADMIN
ENV KEYCLOAK_ADMIN_PASSWORD=KEYCLOAK_ADMIN_PASSWORD

# Copy your realm.json file into the container
COPY realm.json /opt/keycloak/data/import/realm.json

# Set the command to start Keycloak with the import option
# This assumes the realm.json is compatible and doesn't need transformation
CMD ["start-dev", "--import-realm"]