# Restaurant Reservation & Event Management Database (SQL)

This project implements a relational database system inspired by Adria Bar & Restaurant, a high-volume waterfront venue located in Darling Harbour, Sydney, where I worked as a waiter.

The database models real operational reservation processes, including both standard bookings and structured private events.

## Reservation vs Event Logic

The system distinguishes between:

- **Standard reservations**: small parties (e.g., couples or families) booking a table.
- **Event-based reservations**: larger or special occasions such as birthdays or corporate functions.

In the database design, an *Event* is modeled as a specialized extension of a Reservation.  
This allows the system to store additional event-specific information and assign dedicated staff members (runners, waiters, bartenders, managers) through a many-to-many relationship.

This structural separation ensures clarity in the reservation lifecycle while enabling scalable resource allocation for complex bookings.

## Key Features

- Fully normalized relational schema
- Primary and foreign key constraints with referential integrity
- Business rule enforcement via CHECK constraints (reservation status, staff roles)
- Many-to-many relationship modeling (staff-event assignments)
- Table availability tracking
- Analytical SQL views:
  - Upcoming reservations
  - Staff event assignments
  - Table status overview

## Design Objectives

The database was structured to reflect real-world operational needs:

- Structured reservation tracking
- Controlled state transitions (Requested → Booked → Seated / Cancelled / NoShow)
- Clear resource allocation logic
- Data integrity and consistency enforcement
- Operational visibility of upcoming events and bookings

## Technologies

- SQL
- Relational database design
- Constraint-based data integrity enforcement
