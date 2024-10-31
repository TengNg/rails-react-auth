import axios from "axios";

const BASE_URL = import.meta.env.VITE_SERVER_URL || 'http://localhost:3000';

const api = axios.create({
    baseURL: BASE_URL,
    withCredentials: true,
    headers: { 'Content-Type': 'application/json' }
});

api.interceptors.response.use(
    response => response,
    async (error) => {
        const originalRequest = error?.config;
        if (error?.response?.status === 401 && !("_retry" in originalRequest)) {
            originalRequest._retry = true;
            try {
                await api.post('/auth/refresh');
                return api(originalRequest);
            } catch (error) {
                await api.delete('/auth/logout');
                window.location.reload();
            }
        }
        return Promise.reject(error);
    }
);

export { api };

