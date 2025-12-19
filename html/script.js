// ═══════════════════════════════════════════════════════════════
// GREENZONE420 - MODERN FIVEM CLOTHING UI - JAVASCRIPT
// ═══════════════════════════════════════════════════════════════

let currentClothing = {};
let savedOutfits = [];
let jobUniforms = [];
let playerBalance = { cash: 0, bank: 0 };
let discount = 0;

// Clothing Categories with Icons and Names
// Maps UI categories to GTA V component/prop names that Lua expects
const clothingCategories = {
    'tshirt': { name: 'Unterhemd', icon: 'fa-tshirt', price: 25, component: 'tshirt_1', texture: 'tshirt_2', drawableId: 8 },
    'torso': { name: 'Oberteil / Jacke', icon: 'fa-shirt', price: 50, component: 'torso_1', texture: 'torso_2', drawableId: 11 },
    'pants': { name: 'Hose', icon: 'fa-person', price: 40, component: 'pants_1', texture: 'pants_2', drawableId: 4 },
    'shoes': { name: 'Schuhe', icon: 'fa-socks', price: 35, component: 'shoes_1', texture: 'shoes_2', drawableId: 6 },
    'mask': { name: 'Maske', icon: 'fa-mask', price: 50, component: 'mask_1', texture: 'mask_2', drawableId: 1 },
    'glasses': { name: 'Brille', icon: 'fa-glasses', price: 30, component: 'glasses_1', texture: 'glasses_2', propId: 1 },
    'helmet': { name: 'Helm / Hut', icon: 'fa-hard-hat', price: 75, component: 'helmet_1', texture: 'helmet_2', propId: 0 },
    'ears': { name: 'Ohren / Kopfhörer', icon: 'fa-headphones', price: 20, component: 'ears_1', texture: 'ears_2', propId: 2 },
    'watches': { name: 'Uhr', icon: 'fa-clock', price: 100, component: 'watches_1', texture: 'watches_2', propId: 6 },
    'bracelets': { name: 'Armband', icon: 'fa-ring', price: 50, component: 'bracelets_1', texture: 'bracelets_2', propId: 7 },
    'chain': { name: 'Kette', icon: 'fa-gem', price: 60, component: 'chain_1', texture: 'chain_2', drawableId: 7 },
    'bags': { name: 'Tasche / Rucksack', icon: 'fa-bag-shopping', price: 80, component: 'bags_1', texture: 'bags_2', drawableId: 5 },
    'vest': { name: 'Kugelsichere Weste', icon: 'fa-shield-halved', price: 200, component: 'bproof_1', texture: 'bproof_2', drawableId: 9 },
    'decals': { name: 'Abzeichen / Patches', icon: 'fa-star', price: 30, component: 'decals_1', texture: 'decals_2', drawableId: 10 },
    'arms': { name: 'Arme / Ärmel', icon: 'fa-hand-fist', price: 0, component: 'arms', texture: 'arms_2', drawableId: 3 }
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
    const componentName = categoryData.component;
    const textureName = categoryData.texture;
    const isProp = categoryData.propId !== undefined;
    
    // Get current value
    let currentValue = currentClothing[componentName] || (isProp ? -1 : 0);
    
    // Update value
    currentValue += direction;
    
    // Clamp value to valid GTA V ranges
    if (isProp) {
        currentValue = Math.max(-1, Math.min(20, currentValue));  // Props: -1 (none) to 20
    } else {
        currentValue = Math.max(0, Math.min(50, currentValue));   // Components: 0 to 50
    }
    
    // Update local data
    currentClothing[componentName] = currentValue;
    currentClothing[textureName] = 0; // Reset texture to 0
    
    // Update UI display
    $(`#value-${category}`).text(currentValue);
    
    // Send to Lua for LIVE PREVIEW
    $.post('https://mtj_kleidung/updateClothing', JSON.stringify({
        component: componentName,
        value: currentValue,
        texture: 0
    }));
    
    // Visual feedback
    $(`.item-card[data-category="${category}"]`).addClass('active');
    setTimeout(() => {
        $(`.item-card[data-category="${category}"]`).removeClass('active');
    }, 300);
}

function updateAllClothingValues() {
    Object.keys(clothingCategories).forEach(categoryKey => {
        const category = clothingCategories[categoryKey];
        const componentName = category.component;
        const isProp = category.propId !== undefined;
        
        let currentValue = currentClothing[componentName] || (isProp ? -1 : 0);
        
        $(`#value-${categoryKey}`).text(currentValue);
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
