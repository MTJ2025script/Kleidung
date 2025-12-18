// MTJ2024_Kleidung - NUI Script
let currentData = null;
let currentClothing = {};
let selectedCategory = null;
let pendingPaymentAction = null;
let isRotationPaused = false;

// Clothing categories with icons
const clothingCategories = {
    'tshirt': { icon: 'fa-vest', label: 'Unterhemd' },
    'torso': { icon: 'fa-shirt', label: 'Oberteil' },
    'arms': { icon: 'fa-hand', label: 'Arme' },
    'pants': { icon: 'fa-person-dress', label: 'Hose' },
    'shoes': { icon: 'fa-shoe-prints', label: 'Schuhe' },
    'bags': { icon: 'fa-bag-shopping', label: 'Taschen' },
    'chain': { icon: 'fa-gem', label: 'Kette' },
    'decals': { icon: 'fa-award', label: 'Abzeichen' },
    'helmet': { icon: 'fa-hard-hat', label: 'Helm' },
    'glasses': { icon: 'fa-glasses', label: 'Brille' },
    'ears': { icon: 'fa-headphones', label: 'Ohren' }
};

// Listen for NUI messages
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openMenu':
            openMenu(data.data);
            break;
        case 'updateMoney':
            updateMoney(data.data);
            break;
        case 'paymentResult':
            handlePaymentResult(data.success, data.message);
            break;
    }
});

// Open menu
function openMenu(data) {
    currentData = data;
    currentClothing = data.currentClothing || {};
    
    // Update money display
    updateMoney(data.money);
    
    // Update discount banner
    if (data.discount && data.discount > 0) {
        $('#discountBanner').show();
        $('#discountText').text(`Berufsrabatt: ${data.discount}% auf Kleidungsänderungen`);
    } else {
        $('#discountBanner').hide();
    }
    
    // Update cost info
    $('#totalCost').text(data.costs.clothingChange);
    
    // Load categories
    loadCategories(data.availableClothing);
    
    // Load outfits
    loadOutfits(data.outfits);
    
    // Load role outfits
    loadRoleOutfits(data.roleOutfits);
    
    // Show menu
    $('#app').removeClass('hidden');
}

// Update money display
function updateMoney(money) {
    $('#cashBalance').text(money.cash.toLocaleString());
    $('#bankBalance').text(money.bank.toLocaleString());
}

// Load clothing categories
function loadCategories(availableClothing) {
    const grid = $('#categoryGrid');
    grid.empty();
    
    for (const [key, category] of Object.entries(clothingCategories)) {
        if (availableClothing[key] && availableClothing[key] > 0) {
            const card = $(`
                <div class="category-card" data-category="${key}">
                    <i class="fas ${category.icon}"></i>
                    <span>${category.label}</span>
                </div>
            `);
            
            card.on('click', function() {
                selectCategory(key, availableClothing[key]);
            });
            
            grid.append(card);
        }
    }
}

// Select category
function selectCategory(category, maxVariations) {
    selectedCategory = category;
    
    // Update active state
    $('.category-card').removeClass('active');
    $(`.category-card[data-category="${category}"]`).addClass('active');
    
    // Load clothing items for this category
    loadClothingItems(category, maxVariations);
}

// Load clothing items
function loadClothingItems(category, maxVariations) {
    const selection = $('#clothingSelection');
    selection.empty();
    
    const categoryName = clothingCategories[category]?.label || category;
    
    const content = $(`
        <h3>${categoryName}</h3>
        <div class="clothing-items" id="clothingItems"></div>
    `);
    
    selection.append(content);
    
    const itemsGrid = $('#clothingItems');
    
    // Add "None" option for props
    if (['helmet', 'glasses', 'ears'].includes(category)) {
        const noneItem = $(`
            <div class="clothing-item" data-value="-1">
                <i class="fas fa-ban"></i>
                <span>Keine</span>
            </div>
        `);
        
        noneItem.on('click', function() {
            updateClothingItem(category, -1, 0);
        });
        
        itemsGrid.append(noneItem);
    }
    
    // Add clothing variations
    for (let i = 0; i < maxVariations; i++) {
        const item = $(`
            <div class="clothing-item" data-value="${i}">
                <div class="item-preview">
                    <i class="fas fa-tshirt"></i>
                </div>
                <span>#${i}</span>
            </div>
        `);
        
        // Check if this is the current item
        const currentValue = currentClothing[category + '_1'] || currentClothing[category];
        if (currentValue === i) {
            item.addClass('selected');
        }
        
        item.on('click', function() {
            updateClothingItem(category, i, 0);
        });
        
        itemsGrid.append(item);
    }
}

// Update clothing item
function updateClothingItem(category, value, texture) {
    // Update current clothing
    if (['helmet', 'glasses', 'ears'].includes(category)) {
        currentClothing[category] = value;
    } else {
        currentClothing[category + '_1'] = value;
        currentClothing[category + '_2'] = texture;
    }
    
    // Update selection visual
    $('.clothing-item').removeClass('selected');
    $(`.clothing-item[data-value="${value}"]`).addClass('selected');
    
    // Send update to client
    $.post('https://mtj_kleidung/updateClothing', JSON.stringify({
        component: category + '_1',
        value: value,
        texture: texture
    }));
}

// Load outfits
function loadOutfits(outfits) {
    const grid = $('#outfitsGrid');
    grid.empty();
    
    if (!outfits || outfits.length === 0) {
        grid.append(`
            <div style="color: rgba(255,255,255,0.5); text-align: center; padding: 40px;">
                <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px;"></i>
                <p>Keine gespeicherten Outfits</p>
            </div>
        `);
        return;
    }
    
    outfits.forEach(outfit => {
        const card = $(`
            <div class="outfit-card">
                <div class="outfit-card-header">
                    <span class="outfit-name">${outfit.name}</span>
                    <div class="outfit-actions">
                        <button class="load-btn" title="Laden">
                            <i class="fas fa-check"></i>
                        </button>
                        <button class="delete-btn" title="Löschen">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            </div>
        `);
        
        card.find('.load-btn').on('click', function() {
            loadOutfit(outfit);
        });
        
        card.find('.delete-btn').on('click', function() {
            deleteOutfit(outfit.name);
        });
        
        grid.append(card);
    });
}

// Load role outfits
function loadRoleOutfits(roleOutfits) {
    const grid = $('#roleOutfitsGrid');
    grid.empty();
    
    if (!roleOutfits || roleOutfits.length === 0) {
        grid.append(`
            <div style="color: rgba(255,255,255,0.5); text-align: center; padding: 40px;">
                <i class="fas fa-briefcase" style="font-size: 48px; margin-bottom: 15px;"></i>
                <p>Keine Berufs-Outfits verfügbar</p>
            </div>
        `);
        return;
    }
    
    roleOutfits.forEach(outfit => {
        const card = $(`
            <div class="role-outfit-card">
                <div class="role-outfit-header">
                    <div class="role-outfit-icon">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <div class="role-outfit-name">${outfit.label}</div>
                </div>
                <div class="role-outfit-description">Klicke um dieses Outfit anzulegen</div>
            </div>
        `);
        
        card.on('click', function() {
            loadRoleOutfit(outfit.outfit);
        });
        
        grid.append(card);
    });
}

// Switch tabs
function switchTab(tab) {
    // Update tab buttons
    $('.tab-btn').removeClass('active');
    $(`.tab-btn[data-tab="${tab}"]`).addClass('active');
    
    // Update tab content
    $('.tab-content').removeClass('active');
    $(`#${tab}-tab`).addClass('active');
}

// Show payment dialog
function showPaymentDialog() {
    if (!currentData.paymentEnabled) {
        // Free clothing
        closeMenu(true);
        return;
    }
    
    const cost = currentData.costs.clothingChange;
    
    if (cost === 0) {
        // Free due to discount
        closeMenu(true);
        return;
    }
    
    pendingPaymentAction = 'clothing';
    
    $('#paymentAmount').text(cost);
    $('#paymentReason').text('Kleidungsänderung');
    $('#cashPaymentBalance').text(currentData.money.cash + '$');
    $('#bankPaymentBalance').text(currentData.money.bank + '$');
    
    // Check if sufficient funds
    if (currentData.money.cash < cost) {
        $('#cashPaymentBtn').addClass('insufficient');
    } else {
        $('#cashPaymentBtn').removeClass('insufficient');
    }
    
    if (currentData.money.bank < cost) {
        $('#bankPaymentBtn').addClass('insufficient');
    } else {
        $('#bankPaymentBtn').removeClass('insufficient');
    }
    
    // Show/hide payment methods
    if (!currentData.allowCash) {
        $('#cashPaymentBtn').hide();
    }
    if (!currentData.allowBank) {
        $('#bankPaymentBtn').hide();
    }
    
    $('#paymentModal').addClass('active');
}

// Close payment dialog
function closePaymentDialog() {
    $('#paymentModal').removeClass('active');
    pendingPaymentAction = null;
}

// Process payment
function processPayment(method) {
    const cost = pendingPaymentAction === 'clothing' ? 
        currentData.costs.clothingChange : 
        currentData.costs.outfitSave;
    
    const money = method === 'cash' ? currentData.money.cash : currentData.money.bank;
    
    if (money < cost) {
        showNotification('Nicht genügend Geld!', 'error');
        return;
    }
    
    // Send payment request
    $.post('https://mtj_kleidung/processPayment', JSON.stringify({
        amount: cost,
        method: method,
        reason: pendingPaymentAction
    }));
    
    closePaymentDialog();
}

// Handle payment result
function handlePaymentResult(success, message) {
    if (success) {
        showNotification('Zahlung erfolgreich!', 'success');
        
        if (pendingPaymentAction === 'clothing') {
            closeMenu(true);
        }
    } else {
        showNotification('Zahlung fehlgeschlagen!', 'error');
    }
    
    pendingPaymentAction = null;
}

// Show save outfit dialog
function showSaveOutfitDialog() {
    if (currentData.outfits.length >= currentData.maxOutfits) {
        showNotification(`Maximale Anzahl an Outfits erreicht (${currentData.maxOutfits})`, 'error');
        return;
    }
    
    $('#outfitName').val('');
    $('#saveOutfitCost').text(currentData.costs.outfitSave);
    $('#saveOutfitModal').addClass('active');
}

// Close save outfit dialog
function closeSaveOutfitDialog() {
    $('#saveOutfitModal').removeClass('active');
}

// Save outfit
function saveOutfit() {
    const name = $('#outfitName').val().trim();
    
    if (!name) {
        showNotification('Bitte gib einen Namen ein!', 'error');
        return;
    }
    
    // Check if payment is required
    if (currentData.paymentEnabled && currentData.costs.outfitSave > 0) {
        pendingPaymentAction = 'outfit';
        closeSaveOutfitDialog();
        
        $('#paymentAmount').text(currentData.costs.outfitSave);
        $('#paymentReason').text(`Outfit "${name}" speichern`);
        $('#cashPaymentBalance').text(currentData.money.cash + '$');
        $('#bankPaymentBalance').text(currentData.money.bank + '$');
        
        // Check sufficient funds
        if (currentData.money.cash < currentData.costs.outfitSave) {
            $('#cashPaymentBtn').addClass('insufficient');
        } else {
            $('#cashPaymentBtn').removeClass('insufficient');
        }
        
        if (currentData.money.bank < currentData.costs.outfitSave) {
            $('#bankPaymentBtn').addClass('insufficient');
        } else {
            $('#bankPaymentBtn').removeClass('insufficient');
        }
        
        $('#paymentModal').addClass('active');
    } else {
        // Free save
        $.post('https://mtj_kleidung/saveOutfit', JSON.stringify({
            name: name,
            outfit: currentClothing,
            slot: currentData.outfits.length + 1
        }));
        
        closeSaveOutfitDialog();
        showNotification('Outfit gespeichert!', 'success');
    }
}

// Load outfit
function loadOutfit(outfit) {
    $.post('https://mtj_kleidung/loadOutfit', JSON.stringify({
        outfit: outfit
    }));
    
    showNotification(`Outfit "${outfit.name}" geladen!`, 'success');
}

// Delete outfit
function deleteOutfit(name) {
    if (confirm(`Möchtest du das Outfit "${name}" wirklich löschen?`)) {
        $.post('https://mtj_kleidung/deleteOutfit', JSON.stringify({
            name: name
        }));
        
        showNotification(`Outfit "${name}" gelöscht!`, 'success');
    }
}

// Load role outfit
function loadRoleOutfit(outfit) {
    $.post('https://mtj_kleidung/loadRoleOutfit', JSON.stringify({
        outfit: outfit
    }));
    
    showNotification('Berufs-Outfit angelegt!', 'success');
}

// Close menu
function closeMenu(save) {
    $('#app').addClass('hidden');
    
    $.post('https://mtj_kleidung/closeMenu', JSON.stringify({
        save: save
    }));
}

// Show notification
function showNotification(text, type = 'info') {
    const notification = $('#notification');
    notification.removeClass('success error');
    
    if (type === 'success') {
        notification.addClass('success');
    } else if (type === 'error') {
        notification.addClass('error');
    }
    
    $('#notificationText').text(text);
    notification.addClass('show');
    
    setTimeout(() => {
        notification.removeClass('show');
    }, 3000);
}

// Preview controls
$('#pauseRotation').on('click', function() {
    $.post('https://mtj_kleidung/pauseRotation', JSON.stringify({}), function(result) {
        isRotationPaused = result.paused;
        if (isRotationPaused) {
            $('#pauseRotation').addClass('active');
            $('#pauseRotation i').removeClass('fa-pause').addClass('fa-play');
        } else {
            $('#pauseRotation').removeClass('active');
            $('#pauseRotation i').removeClass('fa-play').addClass('fa-pause');
        }
    });
});

$('#resetView').on('click', function() {
    $.post('https://mtj_kleidung/resetView', JSON.stringify({}));
    if (isRotationPaused) {
        $('#pauseRotation').click();
    }
});

// ESC key to close
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        if ($('#paymentModal').hasClass('active')) {
            closePaymentDialog();
        } else if ($('#saveOutfitModal').hasClass('active')) {
            closeSaveOutfitDialog();
        } else if (!$('#app').hasClass('hidden')) {
            closeMenu(false);
        }
    }
});
