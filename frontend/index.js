import { backend } from "declarations/backend";

document.addEventListener('DOMContentLoaded', () => {
    loadItems();

    // Add item form submission
    document.getElementById('add-item-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        const input = document.getElementById('item-input');
        const text = input.value.trim();
        
        if (text) {
            await backend.addItem(text);
            input.value = '';
            await loadItems();
        }
    });
});

async function loadItems() {
    const items = await backend.getAllItems();
    const list = document.getElementById('shopping-list');
    list.innerHTML = '';
    
    items.forEach(item => {
        const li = document.createElement('li');
        li.className = `shopping-item ${item.completed ? 'completed' : ''}`;
        
        li.innerHTML = `
            <i class="fas fa-check" onclick="window.toggleItem(${item.id})"></i>
            <span>${item.text}</span>
            <i class="fas fa-trash" onclick="window.deleteItem(${item.id})"></i>
        `;
        
        list.appendChild(li);
    });
}

// Make these functions available to the window object for the onclick handlers
window.toggleItem = async (id) => {
    await backend.toggleItem(id);
    await loadItems();
};

window.deleteItem = async (id) => {
    await backend.deleteItem(id);
    await loadItems();
};
