const backendUrl = 'http://3.17.11.122:3000';

function submitForm() {
    const username = document.getElementById('username').value;
    const phone = document.getElementById('phone').value;

    fetch(`${backendUrl}/submit`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ username, phone }),
    })
    .then(response => response.json())
    .then(data => {
        window.location.href = `welcome.html?username=${data.username}`;
    })
    .catch(error => console.error('Error:', error));
}

function viewDb() {
    fetch(`${backendUrl}/viewDb`)
    .then(response => response.json())
    .then(data => {
        // Display data in the console for now (modify as needed)
        console.log('All data from DynamoDB:', data);
    })
    .catch(error => console.error('Error fetching data:', error));
}
