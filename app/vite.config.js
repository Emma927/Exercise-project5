import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';
// import { imagetools } from 'vite-imagetools'; Wszystko, co jest w public/, jest kopiowane wprost do dist/ podczas builda.
// Pliki w public/ nie przechodzą przez proces bundlera ani pluginów Vite (w tym vite-imagetools).
// To oznacza, że obrazy w public/ nie będą transformowane ani optymalizowane, niezależnie od pluginów.

/**
 * Path to helpHub folder
 */
// const eCommercePath = './app';

/**
 * Don't change those lines below
 */

// https://vite.dev/config/
export default defineConfig({
  // root: eCommercePath,
  server: {
    host: true,
    port: 3000,
    open: false,
  },
  test: {
    coverage: {
      reporter: ['html'],
    },
    environment: 'jsdom', // <- potrzebne dla RTL, to React Testing Library:

    // -nie renderuje komponentu w prawdziwej przeglądarce, tylko tworzy symulowany DOM (za pomocą jsdom) — w pamięci, w środowisku testowym.
    globals: true, // <- dodajemy globalne expect, test, describe - umożliwia to pomijanie importów:describe, expect, czy test z bibloteki vitest
    include: ['**/*.{spec,test}.{js,jsx}'],
    exclude: ['**/e2e/**'],
    //setupFiles w konfiguracji Vitest (vitest.config.js) służy do inicjalizacji środowiska testowego przed każdym testem. Dzięki temu nie musisz powtarzać importu w każdym pliku testowym.
    setupFiles: ['./setupTests.js'], // <- inicjalizacja jest-dom
    //Jeśli chcesz uruchomić więcej niż jeden plik setup:
    // setupFiles: ["./vitest.setup.js", "./anotherSetup.js"]
  },
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'), // Alias @ w resolve.alias pozwala używać skróconej ścieżki do katalogu src, co upraszcza importy.
    },
  },
});
