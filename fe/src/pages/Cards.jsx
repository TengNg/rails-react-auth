import { useNavigate } from "react-router-dom";
import { useCardsQuery } from "../hooks/useCardsQuery"

const Cards = () => {
    const cardsQuery = useCardsQuery();
    const navigate = useNavigate();

    if (cardsQuery.isPending) {
        return <div>loading...</div>
    }

    if (cardsQuery.isError) {
        return <div>Failed to fetch cards</div>
    }

    return (
        <div>
            <h3>Cards</h3>
            <div className='max-h-[300px] overflow-auto'>
                <pre>{JSON.stringify(cardsQuery.data, null, 2) }</pre>
            </div>

            <button onClick={() => navigate(-1)}>back</button>
        </div>
    )
}

export default Cards
