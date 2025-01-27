import { Route, Routes } from 'react-router-dom';
import Home from './pages/Home';
import Cards from './pages/Cards';
import Register from './pages/Register';
import Admin from './pages/Admin';
import Login from './pages/Login';
import { CurrentUserContextProvider } from './context/CurrentUserContext'
import RequireAuth from './components/auth/RequireAuth';

const ROLES = {
    ADMIN: 'admin',
    USER: 'user',
};

function ProtectedRoute({ allowedRoles }) {
    return (
        <CurrentUserContextProvider>
            <RequireAuth allowedRoles={allowedRoles} />
        </CurrentUserContextProvider>
    )
}

function App() {
    return (
        <>
            <Routes>
                <Route element={<ProtectedRoute allowedRoles={[ROLES.ADMIN, ROLES.USER]} />}>
                    <Route path="/" element={<Home />} />
                    <Route path="/cards" element={<Cards />} />
                </Route>

                <Route element={<ProtectedRoute allowedRoles={[ROLES.ADMIN]} />}>
                    <Route path="/admin/test" element={<Admin />} />
                </Route>

                <Route path="/login" element={<Login />} />
                <Route path="/register" element={<Register />} />
            </Routes>
        </>
    )
}

export default App
