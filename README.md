# Monochrome

## Description

Monochrome is a captivating puzzle game designed to challenge and engage players with a series of increasingly 
complex levels. The primary goal of this project was to create an enjoyable and mentally stimulating game experience
that leverages modern iOS development practices. It addresses the need for high-quality, interactive puzzle games 
in the App Store. Through this project, I aimed to refine my skills in Swift, SwiftUI, and backend integration, 
and to create a platform that can be expanded with new levels and features in the future.

## Features

- **Challenging Levels**: Over 50 unique levels that increase in complexity as the player progresses. (In Progress)
- **Interactive UI**: Smooth and intuitive user interface with animations.
- **Hints System**: A built-in hints system to assist players when they are stuck.
- **Level Selection**: Ability to select and replay previously completed levels.
- **Progress Tracking**: Tracks player progress and scores.
- **Backend Integration**: Fetches level data from a Django backend hosted on AWS. (In Progress)

<img src="https://github.com/user-attachments/assets/cda4364d-842a-4378-8ee2-19bd994b1598" alt="Monochrome Screenshot" width="250">
<img src="https://github.com/user-attachments/assets/e7a33a13-611c-4add-88b4-df549583d603" alt="Monochrome Screenshot" width="250">
<img src="https://github.com/user-attachments/assets/29e2cf90-a17f-41c6-a5e8-56e0a1e9f701" alt="Monochrome Screenshot" width="250">
<img src="https://github.com/user-attachments/assets/5c846df4-69cf-4b74-bd89-bbf1ac5fb3da" alt="Monochrome Screenshot" width="250">
<img src="https://github.com/user-attachments/assets/0cdea865-6a66-4121-9d0b-744651e4c1fb" alt="Monochrome Screenshot" width="250">
<img src="https://github.com/user-attachments/assets/ca59ecea-fc1b-4ccd-b9cb-e04aeddde497" alt="Monochrome Screenshot" width="250">

## How to Use

### Installation

1. **Clone the repository to your local machine:**
    ```bash
    git clone https://github.com/yourusername/monochrome.git
    ```
2. **Navigate to the project directory:**
    ```bash
    cd monochrome
    ```
3. **Set up the project using Tuist:**
    - Install Tuist if you haven't already:
        ```bash
        curl -Ls https://install.tuist.io | bash
        ```
    - Generate the Xcode project with Tuist (this command will also open the project in Xcode):
        ```bash
        tuist generate
        ```
4. **Run the project on a simulator or a connected device from Xcode.**

### Usage

1. **Launch the Monochrome app.**
2. **Tap on the cells to change their colors and solve the puzzle.**
3. **Use the hints button if you get stuck.**
4. **Progress through the levels and track your scores.**

## Technologies

- **Swift**: Primary programming language for iOS development.
- **SwiftUI**: Framework for building user interfaces across all Apple platforms.
- **Tuist**: A tool to generate, maintain and interact with Xcode projects at scale.
- **Django**: Backend framework for managing game levels and user data.
- **AWS**: Hosting the backend on AWS Elastic Beanstalk and storing static files on S3.
- **JSON**: For level data serialization and deserialization.
- **GitHub Actions**: For CI/CD pipeline to ensure code quality and automate deployments.

## Collaborators

- **Alexey Turulin**: [GitHub Profile](https://github.com/repakuku])

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
