import { useQuery } from '@tanstack/react-query'
import { fetchCurrentUser } from '../api/userApi'

export const useCurrentUserQuery = () => {
    return useQuery({
        queryKey: ['profile'],
        queryFn: () => fetchCurrentUser(),
    });
}
