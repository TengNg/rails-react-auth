import { api as axios } from "./axios";

export const fetchAdminTest = async () => {
    const response = await axios.get(`/admin/test`);
    if (response.status !== 200) throw new Error('Failed to fetch');
    return response.data;
}
