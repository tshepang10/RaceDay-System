# RaceDay-System

<img width="1886" height="902" alt="image" src="https://github.com/user-attachments/assets/1ed11915-a323-42ca-a013-e480f13ac187" />
# RaceDay – Part 1: System Planning and Database

## Portfolio of Evidence (PoE)

RaceDay is a full-stack web-based event management system designed for the South African road running, walking and cycling community.

The system is intended to allow event organisers to create and manage sporting events, categories and participant results. Participants will be able to create accounts, browse upcoming events, enter events, view their enrolments and track their personal performance history.

Part 1 focuses on planning the system and designing the database before application development begins.

---

## Project Overview

RaceDay is being developed progressively across three parts:

- **Part 1:** System Planning and Database
- **Part 2:** RESTful API Development using C#
- **Part 3:** MVC Web Application, Azure Blob Storage and Docker

Part 1 establishes the database structure and API design that will be used as the foundation for Parts 2 and 3.

No API application code is written in Part 1.

---

# Part 1 – System Planning and Database

## Objectives

The objectives of Part 1 are to:

- Design a relational database for the RaceDay system.
- Create an Entity Relationship Diagram (ERD).
- Identify primary keys and foreign keys.
- Define relationships and cardinality between entities.
- Plan the RESTful API endpoints.
- Create the SQL Server database schema.
- Populate the database with realistic sample data.
- Demonstrate role-based system planning for Organisers and Participants.

---

# User Roles

The RaceDay system supports two main user roles.

## Organiser

An Organiser can:

- Create events.
- Edit events.
- Delete events.
- Create and manage event categories.
- View event enrolments.
- Capture participant results.
- View participant results.

## Participant

A Participant can:

- Create an account.
- Log into the system.
- Browse available events.
- View event categories.
- Enter an event.
- View their own enrolments.
- View their personal results.

Role-based access will be enforced at the API level in Part 2 and reflected in the MVC application in Part 3.

---

# Database Design

The RaceDay database is designed using a relational database structure.

The main entities include:

1. **User**
2. **Event**
3. **Category**
4. **Enrolment**
5. **Result**
6. **Organiser**

The database uses primary keys and foreign keys to maintain relationships between the entities.

The database also includes appropriate constraints such as:

- `PRIMARY KEY`
- `FOREIGN KEY`
- `NOT NULL`
- `UNIQUE`
- `DEFAULT`

---

# Entity Relationship Diagram

The ERD represents the database structure of the RaceDay system.

It shows:

- Database entities
- Entity attributes
- Primary keys
- Foreign keys
- Relationships
- Relationship cardinality

The ERD is available in the `/docs` folder.

### ERD File

`docs/RaceDay_ERD.png`

---

# API Endpoint Plan

The API endpoint plan was created before development of the RESTful API.

The plan identifies:

- HTTP method
- API route
- Endpoint description
- Required user role
- Request body
- Expected response

The API plan covers the following functional areas:

- Authentication
- User profiles
- Events
- Categories
- Event enrolments
- Results

### API Endpoint Plan

`docs/RaceDay_API_Endpoint_Plan.pdf`

---

# SQL Database Script

The SQL Server database script creates and populates the RaceDay database.

The script includes:

- Database creation
- Table creation
- Primary keys
- Foreign keys
- Constraints
- Sample data
- Organisers
- Participants
- Events
- Event categories
- Enrolments
- Results

### SQL File

`docs/RaceDayDB.sql`

The database script can be opened and executed using Microsoft SQL Server Management Studio (SSMS).

---

# Sample Data

The database is populated with realistic sample data for testing and demonstration purposes.

The sample data includes:

- At least two Organisers
- At least two Participants
- At least three Events
- Categories for each event
- Sample event enrolments
- Sample participant results

---

# API Planning

The planned API follows RESTful principles.

The following HTTP methods are used:

| HTTP Method | Purpose |
|-------------|---------|
| GET | Retrieve information |
| POST | Create new information |
| PUT | Update existing information |
| DELETE | Delete information |

Example planned endpoints include:

```text
POST /api/auth/register
POST /api/auth/login

GET /api/users/me
PUT /api/users/me

GET /api/events
GET /api/events/{id}
POST /api/events
PUT /api/events/{id}
DELETE /api/events/{id}

GET /api/categories
POST /api/events/{eventId}/categories
PUT /api/categories/{id}
DELETE /api/categories/{id}

POST /api/events/{eventId}/enrolments
GET /api/users/me/enrolments
DELETE /api/enrolments/{id}

POST /api/events/{eventId}/results
PUT /api/results/{id}
GET /api/users/me/results
GET /api/events/{eventId}/results
