# Install and run docker

```bash
docker-compose build --no-cache
docker-compose up
```

# Install server dependencies

```bash
docker-compose run api bundle install
```

# force rebuild gems

```bash
docker-compose down --volumes --remove-orphans && docker-compose build --no-cache && docker-compose up
```
