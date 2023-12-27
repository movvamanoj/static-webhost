// script.js
const backendUrl = 'http://3.17.11.122:3000';
function showErrorModal(message) {
    const modal = document.getElementById('errorModal');
    const errorMessageElement = document.getElementById('errorMessage');
    errorMessageElement.textContent = message;

    // Display the modal
    modal.style.display = 'block';

    // Close the modal when the user clicks on the close button (×)
    const closeBtn = document.querySelector('.close');
    closeBtn.onclick = function() {
        modal.style.display = 'none';
    };

    // Close the modal when the user clicks anywhere outside of the modal
    window.onclick = function(event) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    };
}


function submitForm() {
    const username = document.getElementById('username').value;
    const phone = document.getElementById('phone').value;

    // Validate username (alphabets only)
    const usernameRegex = /^[a-zA-Z]+$/;
    if (!usernameRegex.test(username)) {
        showErrorModal('Username must contain only alphabets.');
        return;
    }

    // Validate phone number (numbers only)
    const phoneRegex = /^[0-9]+$/;
    if (!phoneRegex.test(phone)) {
        showErrorModal('Phone number must contain only numbers.');
        return;
    }
    
    
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
    console.log('View DB button clicked');

    fetch(`${backendUrl}/viewDb`)
    .then(response => {
        console.log('Response status:', response.status);
        return response.json();
    })
    .then(data => {
        // Display data in the index.html page
        const dbDataElement = document.getElementById('dbData');
        dbDataElement.innerHTML = ''; // Clear previous data

        // Create a table to display the data
        const table = document.createElement('table');
        table.border = '1';

        // Create table headers
        const headers = ['Username', 'Phone'];
        const headerRow = document.createElement('tr');
        headers.forEach(header => {
            const th = document.createElement('th');
            th.textContent = header;
            headerRow.appendChild(th);
        });
        table.appendChild(headerRow);

        // Create table rows with data
        data.forEach(item => {
            const row = document.createElement('tr');
            Object.values(item).forEach(value => {
                const td = document.createElement('td');
                td.textContent = value;
                row.appendChild(td);
            });
            table.appendChild(row);
        });

        // Append the table to the index.html page
        dbDataElement.appendChild(table);
    })
    .catch(error => console.error('Error fetching data:', error));
}
