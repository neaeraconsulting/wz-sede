package com.wydot.message_generator.utilities;

public class Units {
    public static final double METERS_TO_FEET = 3.28084;
    public static final double FEET_TO_METERS = 1.0 / METERS_TO_FEET;
    public static final double METERS_TO_MILES = 0.000621371;
    public static final double MILES_TO_METERS = 1.0 / METERS_TO_MILES;

    public static double convertMetersToFeet(double meters) {
        return meters * METERS_TO_FEET;
    }

    public static double convertFeetToMeters(double feet) {
        return feet * FEET_TO_METERS;
    }

    public static double convertMetersToMiles(double meters) {
        return meters * METERS_TO_MILES;
    }

    public static double convertMilesToMeters(double miles) {
        return miles * MILES_TO_METERS;
    }
}
