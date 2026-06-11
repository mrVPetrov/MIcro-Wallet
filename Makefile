.PHONY: up down shell migrate test fresh

# Запуск всех сервисов в фоне
up:
	docker compose up -d --build

# Остановка сервисов (данные БД сохраняются)
down:
	docker compose down

# Открыть bash внутри PHP-контейнера
shell:
	docker compose exec --user $$(id -u):$$(id -g) app bash

# Запуск миграций
migrate:
	docker compose exec --user $$(id -u):$$(id -g) app php artisan migrate

# Полная пересборка БД (ОСТОРОЖНО: удаляет все данные!)
fresh:
	docker compose down -v
	docker compose up -d --build
	docker compose exec --user $$(id -u):$$(id -g) app php artisan migrate:fresh --seed

# Запуск тестов в изолированном контейнере
test:
	docker compose run --rm --user $$(id -u):$$(id -g) test php artisan test

# Запуск composer с правильными правами
# Использование: make composer install, make composer require laravel/sanctum
composer:
	docker compose exec --user $$(id -u):$$(id -g) app composer $(filter-out $@,$(MAKECMDGOALS))