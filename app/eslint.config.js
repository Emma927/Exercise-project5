import js from '@eslint/js'
import globals from 'globals'
import reactHooks from 'eslint-plugin-react-hooks'
import reactRefresh from 'eslint-plugin-react-refresh'
import { defineConfig, globalIgnores } from 'eslint/config'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{js,jsx}'],
    extends: [
      js.configs.recommended,
      reactHooks.configs.flat.recommended,
      reactRefresh.configs.vite,
    ],
    languageOptions: {
      ecmaVersion: 2020,
      globals: {
        ...globals.browser,  // dla kodu front-end
        ...globals.node,     // dodaj Node.js, dzięki czemu process.env nie będzie podkreślone, informuje narzędzie, że pewne zmienne są globalnie dostępne w Node.js, np. process, dzięki czemu można je używać w kodzie backendowym bez błędów lintowania.
      },
      parserOptions: {
        ecmaVersion: 'latest',
        ecmaFeatures: { jsx: true },
        sourceType: 'module',
      },
    },
    rules: {
      'no-unused-vars': ['error', { varsIgnorePattern: '^[A-Z_]' }],
    },
     overrides: [
      {
        // linia files w overrides mówi ESLintowi, które pliki mają korzystać z tych globalnych zmiennych.
        files: ['**/*.test.js', '**/*.spec.js', '**/*.test.jsx', '**/*.spec.jsx'],
        // ESLint readonly w overrides → funkcjonuje w edytorze/linterze, nie będzie podkreślał globalnych zmiennych jako undefined.
        globals: {
          describe: 'readonly',
          it: 'readonly',
          test: 'readonly',
          expect: 'readonly',
          beforeEach: 'readonly',
          afterEach: 'readonly',
        },
      },
    ],
  },
])
