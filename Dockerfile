FROM php:8.3-fpm

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    default-mysql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка PHP расширений (включая pdo_mysql)
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Настройка рабочего каталога
WORKDIR /var/www/html

# Копирование файлов проекта (будет перезаписано volume при запуске, но нужно для сборки)
COPY . .

# Настройка прав для storage и bootstrap/cache (важно для Laravel)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache