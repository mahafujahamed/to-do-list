#!/bin/bash

# File to store tasks
TODO_FILE="todo_list.csv"

# Initialize the to-do list file if it doesn't exist
if [ ! -f $TODO_FILE ]; then
    echo "task_name,category,priority,due_date,completed" > $TODO_FILE
fi

# Function to display the tasks
display_tasks() {
    echo "To-Do List:"
    cat $TODO_FILE | tail -n +2 | while IFS=, read -r task category priority due_date completed; do
        echo "Task: $task"
        echo "Category: $category"
        echo "Priority: $priority"
        echo "Due Date: $due_date"
        echo "Completed: $completed"
        echo "-----------------------------"
    done
}

# Function to add a task
add_task() {
    echo "Enter task name:"
    read task_name
    echo "Enter category (e.g., work, personal):"
    read category
    echo "Enter priority (high, medium, low):"
    read priority
    echo "Enter due date (yyyy-mm-dd):"
    read due_date
    echo "Task added (not completed)."

    # Append task to file
    echo "$task_name,$category,$priority,$due_date,not completed" >> $TODO_FILE
}

# Function to delete a task
delete_task() {
    display_tasks
    echo "Enter the task name to delete:"
    read task_name
    sed -i "/^$task_name,/d" $TODO_FILE
    echo "Task deleted."
}

# Function to mark a task as completed
mark_completed() {
    display_tasks
    echo "Enter the task name to mark as completed:"
    read task_name
    sed -i "/^$task_name,/s/not completed/completed/" $TODO_FILE
    echo "Task marked as completed."
}

# Function to sort tasks by priority
sort_tasks() {
    echo "Sorted tasks by priority (high > medium > low):"
    tail -n +2 $TODO_FILE | sort -t',' -k3,3 | while IFS=, read -r task category priority due_date completed; do
        echo "Task: $task"
        echo "Category: $category"
        echo "Priority: $priority"
        echo "Due Date: $due_date"
        echo "Completed: $completed"
        echo "-----------------------------"
    done
}

# Function to import tasks from a CSV file
import_tasks() {
    echo "Enter the CSV file name to import:"
    read import_file
    if [ -f $import_file ]; then
        tail -n +2 $import_file >> $TODO_FILE
        echo "Tasks imported from $import_file."
    else
        echo "File not found!"
    fi
}

# Function to export tasks to a CSV file
export_tasks() {
    echo "Enter the CSV file name to export:"
    read export_file
    cp $TODO_FILE $export_file
    echo "Tasks exported to $export_file."
}

# Main menu
while true; do
    echo "Choose an option:"
    echo "1. Add a task"
    echo "2. View tasks"
    echo "3. Delete a task"
    echo "4. Mark a task as completed"
    echo "5. Sort tasks by priority"
    echo "6. Import tasks from CSV"
    echo "7. Export tasks to CSV"
    echo "8. Exit"
    read choice

    case $choice in
        1)
            display_tasks
            ;;
        2)
            add_task
            ;;
        3)
            delete_task
            ;;
        4)
            mark_completed
            ;;
        5)
            sort_tasks
            ;;
        6)
            import_tasks
            ;;
        7)
            export_tasks
            ;;
        8)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done
