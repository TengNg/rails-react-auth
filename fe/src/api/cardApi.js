import { api as axios } from "./axios";

export const fetchCards = async () => {
    await new Promise(resolve => setTimeout(resolve, 1000));
    const response = await axios.get(`/cards`);
    if (response.status !== 200) throw new Error('Failed to fetch cards');
    return response.data;
}
