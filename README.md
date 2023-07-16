!["Full Stack Kanban App | React Node MongoDB Material-UI"](https://user-images.githubusercontent.com/67447840/177310317-3d9ad738-af83-4cc1-976a-c4a54c1033ff.png "Full Stack Kanban App | React Node MongoDB Material-UI")

# Video tutorial

    https://youtu.be/sqGowdB1tvY

# Reference

    - Create react app:https://create-react-app.dev/
    - React beautiful dnd: https://github.com/atlassian/react-beautiful-dnd/
    - Material-UI: https://mui.com/
    - Express: https://expressjs.com/

# Preview

!["Full Stack Kanban App | React Node MongoDB Material-UI"](https://user-images.githubusercontent.com/67447840/177310521-764f8ff7-5e3d-4644-ac0a-273cf83e48aa.gif "Full Stack Kanban App | React Node MongoDB Material-UI")

# Prerequisites

    - Docker installed on the host Machine
    - docker-compose installed on the host machine

# Running the Application on Docker

 configure maximum ports for backend to connect to database use command `echo fs.inotify.max_user_watches=582222 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p`

provide the backend url to the frontend see `line 3` (if you're running on local machine edit backend and add local host there) [axiosClient](https://github.com/realexcel2021/kanban-app-docker/blob/master/client/src/api/axiosClient.js)

run command `docker-compose up -d`