export default {
  plugins: {
    autoprefixer: {}, // pusty obiekt {} w konfiguracji Autoprefixera oznacza, że używa się domyślnych ustawień dla tej wtyczki.
    ...(process.env.NODE_ENV === 'production' ? { cssnano: {} } : {}),
    // Jeśli jesteśmy w trybie produkcyjnym (NODE_ENV === 'production'), dodajemy cssnano,
    // który minifikuje CSS: usuwa komentarze, łączy podobne reguły i zmniejsza rozmiar plików CSS
    // w trybie development cssnano się nie włącza, żeby łatwiej debugować CSS i nie spowalniać HMR (Hot Module Replacement)
  },
};

// Autoprefixer dodaje niezbędne prefiksy, które starsze przeglądarki wymagają do prawidłowego działania nowszych właściwości CSS, takich jak flexbox czy grid.