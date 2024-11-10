## rails-react-auth

Simple token-based authentication with Rails + React

---

### Features
- JWT-based authentication
- Tokens stored in HTTP-only cookies for security

---

### Setup

#### be (Rails 7+), steps:
- run `bundle install`
- run `rails db:create db:migrate`
- run `rails db:seed`
- create `.env`:
  ```
  # example
  ACCESS_TOKEN_COOKIE_PREFIX=myapp
  REFRESH_TOKEN_COOKIE_PREFIX=myapp
  ACCESS_TOKEN_SECRET=ACCESS_TOKEN_SECRET
  REFRESH_TOKEN_SECRET=REFRESH_TOKEN_SECRET
  FRONTEND_URL=http://localhost:5173
  ```
- run `rails server`

#### fe (React 18+), steps:
- run `npm install`
- run `npm run dev`
- open `http://localhost:5173`
