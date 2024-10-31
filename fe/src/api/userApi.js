import { api as axios } from "./axios";

export const fetchCurrentUser = async () => {
    const response = await axios.get(`/profile`);
    if (response.status !== 200) throw new Error('Failed to fetch current user data');
    return response.data;
}

export const fetchUserByUsername = async (username) => {
    const response = await axios.get(`/users/${username}`);
    if (response.status !== 200) throw new Error('Failed to fetch user data by username');
    return response.data;
}
