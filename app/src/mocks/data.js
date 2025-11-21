import { http, HttpResponse } from 'msw';

export const dataHandlers = [
    http.get(
        "http://example.com/data",
        () => {
            return HttpResponse.json({ name: 'CodersLab'})
        }
    )
];

