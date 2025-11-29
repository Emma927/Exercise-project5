# --- STAGE 1: TESTY E2E (Zawiera wszystko, by uruchomić testy) ---
FROM node:24 AS test_runner
WORKDIR /app

# Kopiowanie CAŁEGO kodu i instalacja WSZYSTKICH zależności (devDependencies i dependencies)
COPY ./app/package*.json ./
RUN npm install
COPY ./app .

# Uruchomienie wszystkich testów (unit, integracyjnych, e2e)
# Jeśli masz dedykowany skrypt np. "test:ci", użyj go tutaj.
# Jeśli testy zakończą się błędem, budowanie obrazu zatrzyma się.

# Uruchomienie wszystkich testów
# Jeśli testy zakończą się błędem, budowanie obrazu zatrzyma się.
RUN npm test

# Instalacja zależności systemowych i przeglądarki Chromium dla Playwright
# Musi być wykonane przez roota.
RUN npx playwright install --with-deps

# 3. Uruchomienie testów E2E (Playwright, używając nowego skryptu 'test:e2e-ci')
RUN npm run test:e2e-ci

# --- STAGE 2: BUDOWANIE APLIKACJI (Kompilacja frontendu) ---
# Używamy etapu development/test_runner jako bazy, bo ma już zainstalowane wszystkie zależności (vite, babel itp.)
FROM test_runner AS builder

# Budowanie aplikacji (tworzenie katalogu 'dist')
RUN npm run build

#ALBO nginx:
# --- STAGE 3: SERWOWANIE GOTOWEJ APLIKACJI PRZEZ NGINX ---
# Używamy lekkiego, bezpiecznego obrazu Nginx Alpine
FROM nginx:alpine AS production_nginx

# Usuwamy domyślny plik konfiguracyjny Nginx, jeśli chcemy użyć własnego
RUN rm /etc/nginx/conf.d/default.conf

# Kopiujemy pliki wynikowe z etapu build do domyślnego katalogu serwowania Nginx
# Nginx domyślnie szuka plików w /usr/share/nginx/html
COPY --from=builder /app/dist /usr/share/nginx/html

# Opcjonalnie: Kopiowanie niestandardowego pliku konfiguracyjnego Nginx (jeśli masz złożoną konfigurację)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# DODAJ TE DWIE LINIE: Zmień właściciela katalogów cache na użytkownika nginx
# RUN chown -R nginx:nginx /var/cache/nginx
# RUN chown -R nginx:nginx /var/run

# Jawne przełączenie na ISTNIEJĄCEGO użytkownika 'nginx'
# USER nginx

# 3. Naprawiamy uprawnienia (to nadal konieczne, żeby Nginx mógł pisać swoje pliki jako non-root)
RUN chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid
# # Przełącz na użytkownika nginx (worker processes będą działały jako nginx)
USER nginx

# Nginx domyślnie działa na porcie 80 i ma wbudowany CMD, nie potrzebujesz npm start

# Odsłonięcie portu (domyślny port Nginx)
EXPOSE 8080

# Domyślny CMD Nginx uruchamia serwer. Nie ruszaj tej linii.
CMD ["nginx", "-g", "daemon off;"]


# STARE: 
# # --- STAGE 1: TESTY E2E (Zawiera wszystko, by uruchomić testy) ---
# FROM node:24 AS test_runner
# WORKDIR /app
# 
# # Kopiowanie CAŁEGO kodu i instalacja WSZYSTKICH zależności (devDependencies i dependencies)
# COPY ./app/package*.json ./
# RUN npm install
# COPY ./app .
# 
# # Uruchomienie wszystkich testów (unit, integracyjnych, e2e)
# # Jeśli masz dedykowany skrypt np. "test:ci", użyj go tutaj.
# # Jeśli testy zakończą się błędem, budowanie obrazu zatrzyma się.
# 
# # Uruchomienie wszystkich testów
# # Jeśli testy zakończą się błędem, budowanie obrazu zatrzyma się.
# RUN npm test
# 
# # Instalacja zależności systemowych i przeglądarki Chromium dla Playwright
# # Musi być wykonane przez roota.
# RUN npx playwright install --with-deps
# 
# # 3. Uruchomienie testów E2E (Playwright, używając nowego skryptu 'test:e2e-ci')
# RUN npm run test:e2e-ci
# 
# # --- STAGE 2: BUDOWANIE APLIKACJI (Kompilacja frontendu) ---
# # Używamy etapu development/test_runner jako bazy, bo ma już zainstalowane wszystkie zależności (vite, babel itp.)
# FROM test_runner AS builder
# 
# # Budowanie aplikacji (tworzenie katalogu 'dist')
# RUN npm run build
# 
# #ALBO nginx:
# # --- STAGE 3: SERWOWANIE GOTOWEJ APLIKACJI PRZEZ NGINX ---
# # Używamy lekkiego, bezpiecznego obrazu Nginx Alpine
# FROM nginx:alpine AS production_nginx
# 
# # Usuwamy domyślny plik konfiguracyjny Nginx, jeśli chcemy użyć własnego
# RUN rm /etc/nginx/conf.d/default.conf
# 
# # Kopiujemy pliki wynikowe z etapu build do domyślnego katalogu serwowania Nginx
# # Nginx domyślnie szuka plików w /usr/share/nginx/html
# COPY --from=builder /app/dist /usr/share/nginx/html
# 
# # Opcjonalnie: Kopiowanie niestandardowego pliku konfiguracyjnego Nginx (jeśli masz złożoną konfigurację)
# COPY nginx.conf /etc/nginx/conf.d/default.conf
# 
# # DODAJ TE DWIE LINIE: Zmień właściciela katalogów cache na użytkownika nginx
# # RUN chown -R nginx:nginx /var/cache/nginx
# # RUN chown -R nginx:nginx /var/run
# 
# # Jawne przełączenie na ISTNIEJĄCEGO użytkownika 'nginx'
# # USER nginx
# 
# # ALBO:
#     # Zmień właściciela katalogów html, cache i run na użytkownika nginx
# # RUN chown -R nginx:nginx /usr/share/nginx/html \
# #     /var/cache/nginx \
# #     /var/run
# # 
# # # Przełącz na użytkownika nginx (worker processes będą działały jako nginx)
# # USER nginx
# 
# # Nginx domyślnie działa na porcie 80 i ma wbudowany CMD, nie potrzebujesz npm start
# 
# # Odsłonięcie portu (domyślny port Nginx)
# EXPOSE 80
# 
# # Domyślny CMD Nginx uruchamia serwer. Nie ruszaj tej linii.
# CMD ["nginx", "-g", "daemon off;"]






# # --- STAGE 3: SERWOWANIE GOTOWEJ APLIKACJI (Bezpieczne środowisko produkcyjne) ---
# # Używamy lekkiego obrazu Alpine
# FROM node:24-alpine AS production
# WORKDIR /app
# 
# # Kopiowanie tylko niezbędnych plików z etapu budowania:
# # 1. Zbudowane pliki wynikowe (dist)
# COPY --from=builder /app/dist ./dist
# # 2. Pliki statyczne (public)
# COPY --from=builder /app/public ./public
# # 3. Plik package.json (potrzebny do npm start)
# COPY --from=builder /app/package.json ./package.json
# 
# # Instalacja tylko zależności produkcyjnych, BEZ vite (Vite nie jest potrzebny do serwowania)
# RUN npm install --only=production --ignore-scripts
# 
# # Utworzenie bezpiecznego użytkownika nieuprzywilejowanego
# RUN adduser -D vitejs
# 
# # Upewnienie się, że utworzony użytkownik ma prawa do katalogu aplikacji
# RUN chown -R vitejs:vitejs /app
# 
# # Przełączenie się na użytkownika nieuprzywilejowanego
# USER vitejs
# 
# # Uruchomienie aplikacji
# # Domyślnie Vite nie ma wbudowanego serwera plików statycznych na produkcji.
# # Musisz użyć narzędzia takiego jak 'serve' lub skonfigurować serwer HTTP (np. Nginx).
# # Zakładając, że chcesz użyć prostego serwera HTTP, musisz go dodać.
# 
# # Alternatywa 1: Użycie prostego serwera HTTP (np. Nginx) - wymagałoby zmiany obrazu bazowego na nginx:alpine
# # Alternatywa 2: Użycie npm start, który w Twoim package.json powinien uruchamiać np. 'serve -s dist'
# # Jeśli Twój package.json ma skrypt 'start' do serwowania, używamy go:
# CMD ["npm", "start"]
# # Odsłonięcie portu (domyślnie 3000 w dev, ale w prod może to być inny port, np. 8080 dla Nginx/serve)
# EXPOSE 3000
# #Dodaktowo potrzbne zainstalowanie przy node npm install serve --save 