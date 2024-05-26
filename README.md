# Todo-Project

## Overview

This script, `todo.sh`, manages a to-do list by allowing the user to create, update, delete, and view tasks. Each task includes details such as a unique identifier, title, description, location, due date, and completion marker. The script handles all data using a file (`tasks.txt`), making it simple and portable.

## Design Choices

### Data Storage

- **File-Based**: The script stores all tasks in a plain text file called `tasks.txt`. Each task occupies a single line, with fields separated by the pipe (`|`) character. 
- **Fields**:
  1. **Identifier**: Unique for each task, calculated automatically.
  2. **Title**: A string, required.
  3. **Description**: A string, optional.
  4. **Location**: A string, optional.
  5. **Due Date**: In the format `YYYY-MM-DD`, required.
  6. **Completion Marker**: Indicates whether the task is completed.

### Program Structure

- **Functions for Task Management**: Each action (create, update, delete, etc.) is encapsulated in its own function to keep the code organized and reusable.
- **Input Validation**: Ensures that all required inputs meet expected formats, especially for dates and unique identifiers.
- **Error Handling**: Redirects error messages to standard error and validates user input to prevent common errors.

## How to Run the Program

### Prerequisites

- A Unix-like environment with Bash.
- Ensure the script is executable: `chmod u+x todo.sh`.

### Usage

Execute the script with one of the following commands based on the desired operation:

- `./todo.sh createTask`: Create a new task. Follow the prompts to enter task details.
- `./todo.sh updateTask`: Update an existing task. You will choose a task to update and then the specific field to update.
- `./todo.sh deleteTask`: Delete a task. You will be prompted to select a task to delete.
- `./todo.sh showInf`: Display all information for a specific task. You will select the task to view.
- `./todo.sh listTasks`: List all tasks for a given day in two output sections (completed and uncompleted).
- `./todo.sh searchTask`: Search for a task by title.
- `./todo.sh`: lists today's tasks by default in two output sections: (completed and uncompleted).

### Examples

- To create a task, run:
  ```bash
  ./todo.sh createTask
  
- To list today's tasks, simply run:
  ```bash
  ./todo.sh
  

