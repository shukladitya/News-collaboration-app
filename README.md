# News App
## Read and share news, notifications of an organization.

![GitHub last commit](https://img.shields.io/github/last-commit/shukladitya/News-collaboration-app?logo=github)
![Lines of code](https://img.shields.io/tokei/lines/github/shukladitya/News-collaboration-app?logo=flutter)

![image1](https://i.ibb.co/k1k8wmQ/IMG-20210501-034801.jpg)



## TechStack
+ Flutter
+ NodeJS
+ ExpressJS
+ MongoDB

## Setup

Before proceeding please download and install [NodeJS](https://nodejs.org/en/download/) because it is required.
1. Download/Clone the Repository
2. Navigate into the Repository folder on your disk using Terminal and open Nodejs folder
3. Make sure that you have the Node and MongoDB installed
4. Run the following command to run the setup,`npm install`
5. Run server.js using node `node server.js`
6. Server will be running on port 3000.
7. To change the port open server.js locate the following and change:
    ```javascript
    app.listen(process.env.PORT||3000,()=>{
	console.log('server running on port 3000');
   });
    ``` 

