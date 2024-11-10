import { Outlet, useNavigate } from 'react-router-dom'
import useCurrentUserContext from '../../hooks/useCurrentUserContext'

export default function RequireAuth() {
    const currentUserQuery = useCurrentUserContext();
    const navigate = useNavigate();

    if (currentUserQuery.isPending) {
        return <h2>loading...</h2>
    }

    if (currentUserQuery.isError) {
        return <div>
            <h2>Failed to fetch profile data</h2>
            <button onClick={() => navigate('/login')}>Login</button>
        </div>
    }

    return <Outlet />
}

