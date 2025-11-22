import '@testing-library/jest-dom/vitest'; // dodanie matecherów z jest-dom, bez tej linii, trzeba wszędzie importować matechery ręcznie na przykład toBeInTheDocument from "@testing-library/jest-dom/matchers"
import { afterAll, afterEach, beforeAll } from 'vitest';
import { server } from '@/mocks/server';

beforeAll(() => {
  server.listen(); // To polecenie przechwytuje wszystkie nasze żądania
  // server.listen({ onUnhandledRequest: "baypass" }); - wtedy znikają ostrzeżenia
});

afterEach(() => {
    server.resetHandlers();
});

afterAll(() => {
    server.close();
});