# Signup Form Quest

## Student
Nour Khoulani

## Track and Task
- Undergraduate track
- Task A: Local Signup Coach Simulation

## About the App
This app checks a name, email, and password before showing a success message.

## Local Signup Coach
The coach displays a preset tip stored in the app. It uses the fixed category `password_help` and does not use the information entered in the form. It does not connect to a server or call an AI model.

## Tests
- Empty fields: Error messages appeared.
- Invalid email: An error message appeared.
- Short password: An error message appeared.
- Valid form: A green success message appeared.
- Local tip: The preset tip appeared after loading.
- Simulated error: An error message and retry button appeared.

## Reflection

### How does the tip feature work?
When I click the tip button, a loading circle appears. Then the app displays a preset tip. If there is an error, the app shows a message and a retry button.

### Which category selects the tip, and what information does it ignore?
The app uses the `password_help` category. It does not use the name, email, or password entered in the form, which keeps that information separate from the tip feature.

## Contribution
I worked on the signup form, local tip feature, testing, and APK build.