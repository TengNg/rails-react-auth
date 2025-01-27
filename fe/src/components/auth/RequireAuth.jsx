import Unauthorized from '../../pages/Unauthorized';
import { Outlet, useNavigate } from 'react-router-dom'
import useCurrentUserContext from '../../hooks/useCurrentUserContext'

export default function RequireAuth({ allowedRoles }) {
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

    const roles = currentUserQuery.data.roles;
    if (roles.length === 0 || !roles.some(role => allowedRoles.includes(role))) {
        return <Unauthorized />
    }

    return <div className="p-8 overflow-auto border-2 border-gray-200">
        <Outlet />
    </div>
}

