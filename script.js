const backendUrl = 'http://18.220.119.198:3000'; // Update with your EC2 public IP

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
