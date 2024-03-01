# User-order-histories

## UI Setup (3001)

### Prerequisites

- Node.js and npm installed.

### Installation

```bash
# Install dependencies
npm install

# Start the UI
npm run start
```

## API Setup (3000)

### Keep the Redis server running on 127.0.0.1:6379

```bash
# Install Ruby dependencies
bundle install

# Create the database (sqlite)
rails db:create
rails db:migrate

# Run import script
rails runner ./script/import_script.rb

# Start the Rails server
rails s

# Start Sidekiq for background jobs
bundle exec sidekiq
```
