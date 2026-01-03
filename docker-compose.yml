version: "3.8"

services:
  app:
    image: ${image}
    container_name: nodejs-shopping-app
    ports:
      - "80:3000"
    environment:
      PORT: "3000"
      MONGODB_URI: "mongodb://mongo:27017/shop"

  mongo:
    image: mongo:6
    container_name: mongo
    volumes:
      - mongo-data:/data/db

volumes:
  mongo-data:
