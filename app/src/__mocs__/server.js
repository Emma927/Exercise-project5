import { setupServer } from 'msw/node';

import { dataHandlers } from "@/data";

const handlers = [...dataHandlers];

export const server = setupServer(...handlers);
