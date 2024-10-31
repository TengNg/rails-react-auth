import { Route, Routes } from 'react-router-dom';
import Home from './pages/Home';
import Cards from './pages/Cards';
import Register from './pages/Register';
import Login from './pages/Login';
import { CurrentUserContextProvider } from './context/CurrentUserContext'
import RequireAuth from './components/auth/RequireAuth';

function App() {
    return (
        <>
            <Routes>
                <Route element={
                    <CurrentUserContextProvider>
                        <RequireAuth />
                    </CurrentUserContextProvider>
                }>
                    <Route path="/" element={<Home />}>
                        <Route path="/cards" element={<Cards />} />
                    </Route>
                </Route>
                <Route path="/login" element={<Login />} />
                <Route path="/register" element={<Register />} />
            </Routes>
        </>
    )
}

export default App
