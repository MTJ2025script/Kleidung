// ═══════════════════════════════════════════════════════════════
// GREENZONE420 - MODERN FIVEM CLOTHING UI - JAVASCRIPT
// ═══════════════════════════════════════════════════════════════

let currentClothing = {};
let savedOutfits = [];
let jobUniforms = [];
let playerBalance = { cash: 0, bank: 0 };
let discount = 0;

// Clothing Categories with Icons and Names
const clothingCategories = {
    'tshirt': { name: 'Unterhemd', icon: 'fa-tshirt', price: 25, component: 8 },
    'torso': { name: 'Oberteil / Jacke', icon: 'fa-shirt', price: 50, component: 11 },
    'pants': { name: 'Hose', icon: 'fa-person', price: 40, component: 4 },
    'shoes': { name: 'Schuhe', icon: 'fa-socks', price: 35, component: 6 },
    'mask': { name: 'Maske', icon: 'fa-mask', price: 50, component: 1 },
    'glasses': { name: 'Brille', icon: 'fa-glasses', price: 30, prop: 1 },
    'helmet': { name: 'Helm / Hut', icon: 'fa-hard-hat', price: 75, prop: 0 },
    'ears': { name: 'Ohren / Kopfhörer', icon: 'fa-headphones', price: 20, prop: 2 },
    'watches': { name: 'Uhr', icon: 'fa-clock', price: 100, prop: 6 },
    'bracelets': { name: 'Armband', icon: 'fa-ring', price: 50, prop: 7 },
    'chain': { name: 'Kette', icon: 'fa-gem', price: 60, component: 7 },
    'bags': { name: 'Tasche / Rucksack', icon: 'fa-bag-shopping', price: 80, component: 5 },
    'vest': { name: 'Kugelsichere Weste', icon: 'fa-shield-halved', price: 200, component: 9 },
    'decals': { name: 'Abzeichen / Patches', icon: 'fa-star', price: 30, component: 10 },
    'arms': { name: 'Arme / Ärmel', icon: 'fa-hand-fist', price: 0, component: 3 }
};

// ═══════════════════════════════════════════════════════════════
// INITIALIZATION
// ═══════════════════════════════════════════════════════════════

$(document).ready(function() {
    console.log('GreenZone420 Clothing UI Initialized');
    
    // NUI Message Handler
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        switch(data.action) {
            case 'openMenu':
                openMenu(data);
                break;
            case 'closeMenu':
                closeMenu(false);
                break;
            case 'updateClothing':
                updateClothingPreview(data.clothing);
                break;
        }
    });
    
    // ESC Key to close
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            closeMenu(false);
        }
    });
    
    // Initialize clothing list
    generateClothingList();
});

// ═══════════════════════════════════════════════════════════════
// MENU CONTROL
// ═══════════════════════════════════════════════════════════════

function openMenu(data) {
    console.log('Opening menu with data:', data);
    
    // Update balance
    if (data.cash !== undefined) {
        playerBalance.cash = data.cash;
        $('#cashBalance').text('$' + formatNumber(data.cash));
    }
    if (data.bank !== undefined) {
        playerBalance.bank = data.bank;
        $('#bankBalance').text('$' + formatNumber(data.bank));
    }
    
    // Update discount
    if (data.discount !== undefined) {
        discount = data.discount;
        if (discount > 0) {
            $('#discountBanner').removeClass('hidden');
            $('#discountText').text(`Rabatt aktiv: ${discount}% auf alle Kleidung!`);
        } else {
            $('#discountBanner').addClass('hidden');
        }
    }
    
    // Set player name
    if (data.playerName) {
        $('#playerDisplayName').text(data.playerName);
    }
    
    // Load current clothing
    if (data.currentClothing) {
        currentClothing = data.currentClothing;
        updateAllClothingValues();
    }
    
    // Load saved outfits
    if (data.outfits) {
        savedOutfits = data.outfits;
        generateOutfitsList();
    }
    
    // Load job uniforms
    if (data.uniforms) {
        jobUniforms = data.uniforms;
        generateUniformsList();
    }
    
    // Show menu
    $('#app').removeClass('hidden');
}

function closeMenu(save) {
    $('#app').addClass('hidden');
    
    // Send close event to Lua
    $.post('https://mtj_kleidung/closeMenu', JSON.stringify({
        save: save,
        clothing: currentClothing
    }));
}

// ═══════════════════════════════════════════════════════════════
// TAB SWITCHING
// ═══════════════════════════════════════════════════════════════

function switchTab(tabName) {
    // Update tab buttons
    $('.tab-btn').removeClass('active');
    $(`.tab-btn[data-tab="${tabName}"]`).addClass('active');
    
    // Update tab content
    $('.tab-content').removeClass('active');
    $(`#${tabName}-tab`).addClass('active');
}

// ═══════════════════════════════════════════════════════════════
// CLOTHING LIST GENERATION
// ═══════════════════════════════════════════════════════════════

function generateClothingList() {
    const listContainer = $('#clothingList');
    listContainer.empty();
    
    Object.keys(clothingCategories).forEach(categoryKey => {
        const category = clothingCategories[categoryKey];
        const isProp = category.prop !== undefined;
        const identifier = isProp ? category.prop : category.component;
        
        // Get current value
        let currentValue = 0;
        let maxValue = 100; // Will be updated from game
        
        if (isProp) {
            currentValue = currentClothing[`${categoryKey}_1`] || 0;
        } else {
            currentValue = currentClothing[categoryKey] || 0;
        }
        
        // Calculate price with discount
        const price = Math.floor(category.price * (1 - discount / 100));
        
        // Create item card
        const itemCard = $(`
            <div class="item-card" data-category="${categoryKey}">
                <div class="item-icon">
                    <i class="fas ${category.icon}"></i>
                </div>
                <div class="item-details">
                    <h4 class="item-name">${category.name}</h4>
                    <p class="item-description">Wähle dein ${category.name}</p>
                </div>
                <div class="item-controls">
                    <button class="item-control-btn prev" data-category="${categoryKey}">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <span class="item-value" id="value-${categoryKey}">
                        ${currentValue} / ${maxValue}
                    </span>
                    <button class="item-control-btn next" data-category="${categoryKey}">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
                <div class="item-price">
                    <i class="fas fa-dollar-sign"></i>
                    <span>${price}</span>
                </div>
            </div>
        `);
        
        listContainer.append(itemCard);
    });
    
    // Attach event listeners
    $('.item-control-btn.prev').click(function() {
        const category = $(this).data('category');
        changeClothingValue(category, -1);
    });
    
    $('.item-control-btn.next').click(function() {
        const category = $(this).data('category');
        changeClothingValue(category, 1);
    });
}

function changeClothingValue(category, direction) {
    const categoryData = clothingCategories[category];
    const isProp = categoryData.prop !== undefined;
    
    // Get current value
    let currentValue = 0;
    if (isProp) {
        currentValue = currentClothing[`${category}_1`] || -1;
    } else {
        currentValue = currentClothing[category] || 0;
    }
    
    // Update value
    currentValue += direction;
    
    // Clamp value (will be validated by server)
    if (currentValue < (isProp ? -1 : 0)) {
        currentValue = isProp ? -1 : 0;
    }
    if (currentValue > 100) { // Max will be updated from server
        currentValue = 100;
    }
    
    // Update local data
    if (isProp) {
        currentClothing[`${category}_1`] = currentValue;
        currentClothing[`${category}_2`] = 0; // Reset texture
    } else {
        currentClothing[category] = currentValue;
    }
    
    // Update UI
    $(`#value-${category}`).text(`${currentValue} / 100`);
    
    // Send to Lua for preview
    $.post('https://mtj_kleidung/previewClothing', JSON.stringify({
        category: category,
        value: currentValue,
        isProp: isProp,
        identifier: isProp ? categoryData.prop : categoryData.component
    }));
    
    // Highlight changed item
    $(`.item-card[data-category="${category}"]`).addClass('active');
    setTimeout(() => {
        $(`.item-card[data-category="${category}"]`).removeClass('active');
    }, 1000);
}

function updateAllClothingValues() {
    Object.keys(clothingCategories).forEach(categoryKey => {
        const category = clothingCategories[categoryKey];
        const isProp = category.prop !== undefined;
        
        let currentValue = 0;
        if (isProp) {
            currentValue = currentClothing[`${categoryKey}_1`] || -1;
        } else {
            currentValue = currentClothing[categoryKey] || 0;
        }
        
        $(`#value-${categoryKey}`).text(`${currentValue} / 100`);
    });
}

// ═══════════════════════════════════════════════════════════════
// OUTFITS
// ═══════════════════════════════════════════════════════════════

function generateOutfitsList() {
    const listContainer = $('#outfitsList');
    listContainer.empty();
    
    if (savedOutfits.length === 0) {
        listContainer.html(`
            <div class="empty-state">
                <i class="fas fa-bookmark"></i>
                <h3>Keine gespeicherten Outfits</h3>
                <p>Speichere dein erstes Outfit!</p>
            </div>
        `);
        return;
    }
    
    savedOutfits.forEach(outfit => {
        const outfitCard = $(`
            <div class="item-card outfit-item" data-outfit-id="${outfit.id}">
                <div class="item-icon">
                    <i class="fas fa-bookmark"></i>
                </div>
                <div class="item-details">
                    <h4 class="item-name">${outfit.name}</h4>
                    <p class="item-description">Gespeichert am ${outfit.date}</p>
                </div>
                <div class="outfit-buttons">
                    <button class="action-btn load-btn" onclick="loadOutfit(${outfit.id})">
                        <i class="fas fa-download"></i>
                        Laden
                    </button>
                    <button class="action-btn delete-btn" onclick="deleteOutfit(${outfit.id})">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
        `);
        
        listContainer.append(outfitCard);
    });
}

function saveOutfit() {
    // Prompt for outfit name
    const name = prompt('Outfit Name:', 'Mein Outfit');
    if (!name) return;
    
    // Send to Lua
    $.post('https://mtj_kleidung/saveOutfit', JSON.stringify({
        name: name,
        clothing: currentClothing
    }));
}

function loadOutfit(outfitId) {
    $.post('https://mtj_kleidung/loadOutfit', JSON.stringify({
        id: outfitId
    }));
}

function deleteOutfit(outfitId) {
    if (!confirm('Outfit wirklich löschen?')) return;
    
    $.post('https://mtj_kleidung/deleteOutfit', JSON.stringify({
        id: outfitId
    }));
}

// ═══════════════════════════════════════════════════════════════
// UNIFORMS
// ═══════════════════════════════════════════════════════════════

function generateUniformsList() {
    const listContainer = $('#uniformsList');
    listContainer.empty();
    
    if (jobUniforms.length === 0) {
        listContainer.html(`
            <div class="empty-state">
                <i class="fas fa-briefcase"></i>
                <h3>Keine Uniformen verfügbar</h3>
                <p>Für deinen aktuellen Job gibt es keine Uniformen.</p>
            </div>
        `);
        return;
    }
    
    jobUniforms.forEach(uniform => {
        const uniformCard = $(`
            <div class="item-card uniform-item" data-uniform-id="${uniform.id}">
                <div class="item-icon police">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <div class="item-details">
                    <h4 class="item-name">${uniform.label}</h4>
                    <p class="item-description">${uniform.description || 'Offizielle Uniform'}</p>
                </div>
                <button class="action-btn apply-btn" onclick="applyUniform('${uniform.id}')">
                    <i class="fas fa-check"></i>
                    Anziehen
                </button>
            </div>
        `);
        
        listContainer.append(uniformCard);
    });
}

function applyUniform(uniformId) {
    $.post('https://mtj_kleidung/applyUniform', JSON.stringify({
        id: uniformId
    }));
}

// ═══════════════════════════════════════════════════════════════
// ACTIONS
// ═══════════════════════════════════════════════════════════════

function saveChanges() {
    closeMenu(true);
}

// ═══════════════════════════════════════════════════════════════
// CAMERA CONTROLS - 3 VIEW SYSTEM (NO ROTATION)
// ═══════════════════════════════════════════════════════════════

function switchCameraView(view) {
    // Update UI buttons
    $('.view-btn').removeClass('active');
    $(`.view-btn[data-view="${view}"]`).addClass('active');
    
    // Send to Lua
    $.post('https://mtj_kleidung/switchView', JSON.stringify({
        view: view
    }));
}

// Keyboard shortcuts for camera views
$(document).keyup(function(e) {
    if ($('#app').hasClass('hidden')) return;
    
    if (e.key === '1') switchCameraView('front');
    if (e.key === '2') switchCameraView('left');
    if (e.key === '3') switchCameraView('right');
});

// ═══════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════

function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function updateClothingPreview(clothing) {
    currentClothing = clothing;
    updateAllClothingValues();
}

// ═══════════════════════════════════════════════════════════════
// CATEGORY FILTER
// ═══════════════════════════════════════════════════════════════

$('.category-chip').click(function() {
    $('.category-chip').removeClass('active');
    $(this).addClass('active');
    
    const category = $(this).data('category');
    
    if (category === 'all') {
        $('.item-card').show();
    } else {
        $('.item-card').hide();
        $(`.item-card[data-category*="${category}"]`).show();
    }
});

console.log('GreenZone420 Clothing UI Ready!');
