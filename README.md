# Job Timer

A Flutter app for tracking time spent on various jobs.

The app should:

1. Be able to create, modify and delete jobs (delete only when no data is attached to a job)
2. Start and stop a timer for work on a job
3. List all jobs and the current time spent working on them.

## Process

### Create a new job listing

- Click the **New Job** button
- Fill out the details for the job in a form.
- Job is added to the jobs list with a time of 00h00.

### Start/Stop timer.

- Select a job from the list by clicking on it.
- Timer screen appears. On the screen is a timer starting at 00h00s00 and a Green Start button
- Tap the button starts the timer and changes the button to a red Stop button.
- Tap the Stop button stops the running timer and changes back to green Start button
- TODO decide if there should be a record button or if the time the button is clicked should automatically save that time as an entry in the db.
