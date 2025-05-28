
const form = document.getElementById('signForm');
const output = document.getElementById('output');

form.addEventListener('submit', async (e) => {
  e.preventDefault();

  const formData = new FormData(form);
  const res = await fetch('/sign', {
    method: 'POST',
    body: formData
  });

  const data = await res.json();
  if (data.installUrl) {
    output.innerHTML = `<a href="${data.installUrl}">Install App</a>`;
  } else {
    output.textContent = 'Signing failed.';
  }
});
