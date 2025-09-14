# need to specify version to avoid bug
FROM node:18-alpine AS builder

WORKDIR /app
# to make a best use of docker cache, we dont change the content of package.json as much as in other file
# so we copy the package.json first, separate from other file, so when theres a change in other file
# docker wont do the step 1,2,3, but will continue from step 4, if we dont separate package.json from other file
# docker will continue from step 2
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html