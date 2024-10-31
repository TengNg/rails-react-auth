import { useQuery } from '@tanstack/react-query'
import { fetchUserByUsername } from '../api/userApi'

export const useUserQuery = (username) => {
    return useQuery({
        queryKey: ['user', username],
        queryFn: () => fetchUserByUsername(username),
    })
}
