import { useQuery } from '@tanstack/react-query'
import { fetchCards } from '../api/cardApi'

export const useCardsQuery = () => {
    return useQuery({
        queryKey: ['cards'],
        queryFn: () => fetchCards()
    });
}
