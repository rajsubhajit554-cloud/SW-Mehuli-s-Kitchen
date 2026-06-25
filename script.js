// Navbar Scroll Effect
window.addEventListener('scroll', () => {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.classList.add('navbar-scrolled');
    } else {
        navbar.classList.remove('navbar-scrolled');
    }
});

// Mobile & Desktop Hamburger Menu Toggle
const hamburger = document.querySelector('.hamburger');
const navLinks = document.querySelector('.nav-links');

hamburger.addEventListener('click', (e) => {
    e.stopPropagation(); // Prevent document click handler from firing immediately
    navLinks.classList.toggle('nav-active');
});

// Close menu when a link is clicked
const navItems = document.querySelectorAll('.nav-links li a');
navItems.forEach(item => {
    item.addEventListener('click', () => {
        navLinks.classList.remove('nav-active');
    });
});

// Close menu when clicking anywhere outside the menu and hamburger button
document.addEventListener('click', (e) => {
    if (navLinks.classList.contains('nav-active')) {
        if (!navLinks.contains(e.target) && !hamburger.contains(e.target)) {
            navLinks.classList.remove('nav-active');
        }
    }
});

// Close menu when user scrolls the page
window.addEventListener('scroll', () => {
    if (navLinks.classList.contains('nav-active')) {
        navLinks.classList.remove('nav-active');
    }
});

// Reveal Elements on Scroll
const revealElements = document.querySelectorAll('.reviews-slider-container, .vibe-text, .contact-container');

const revealOnScroll = () => {
    const windowHeight = window.innerHeight;
    const elementVisible = 150;

    revealElements.forEach((el) => {
        const elementTop = el.getBoundingClientRect().top;
        if (elementTop < windowHeight - elementVisible) {
            el.style.opacity = '1';
            el.style.transform = 'translateY(0)';
            el.style.transition = 'all 0.8s ease-out';
        } else if (!el.style.opacity) {
            el.style.opacity = '0';
            el.style.transform = 'translateY(50px)';
        }
    });
};

window.addEventListener('scroll', revealOnScroll);
// Trigger once on load
revealOnScroll();

// Banner Image Slider (Fade and Scale Effect)
const bannerImages = document.querySelectorAll('.hero-bg img');
let currentImageIndex = 0;

function updateBannerBg(imgElement) {
    const bannerContainer = document.querySelector('.hero-bg');
    if (bannerContainer && imgElement) {
        bannerContainer.style.setProperty('--bg-image', `url("${imgElement.src}")`);
    }
}

function rotateBanner() {
    if (bannerImages.length <= 1) return;
    
    const nextIndex = (currentImageIndex + 1) % bannerImages.length;
    
    // Remove states from all images first
    bannerImages.forEach(img => {
        img.classList.remove('active', 'prev');
    });
    
    // Set classes for smooth transition
    bannerImages[currentImageIndex].classList.add('prev');
    bannerImages[nextIndex].classList.add('active');
    
    updateBannerBg(bannerImages[nextIndex]);
    
    currentImageIndex = nextIndex;
}

if (bannerImages.length > 0) {
    // Ensure the first image is active on start
    bannerImages[0].classList.add('active');
    updateBannerBg(bannerImages[0]);
    if (bannerImages.length > 1) {
        setInterval(rotateBanner, 5000); // Change image every 5 seconds
    }
}

// Reviews Slider Animation
const reviewItems = document.querySelectorAll('.reviews-slider .review-slide');
const reviewDots = document.querySelectorAll('.slider-dots .dot');
const prevBtn = document.querySelector('.prev-btn');
const nextBtn = document.querySelector('.next-btn');
let currentReviewIndex = 0;
let reviewInterval;

function showReview(index) {
    if (reviewItems.length === 0) return;
    
    // Wrap around index
    if (index >= reviewItems.length) {
        currentReviewIndex = 0;
    } else if (index < 0) {
        currentReviewIndex = reviewItems.length - 1;
    } else {
        currentReviewIndex = index;
    }
    
    // Update active classes for reviews
    reviewItems.forEach((item, i) => {
        if (i === currentReviewIndex) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });
    
    // Update active classes for dots
    reviewDots.forEach((dot, i) => {
        if (i === currentReviewIndex) {
            dot.classList.add('active');
        } else {
            dot.classList.remove('active');
        }
    });
}

function startReviewTimer() {
    stopReviewTimer();
    reviewInterval = setInterval(() => {
        showReview(currentReviewIndex + 1);
    }, 5000); // changes review every 5 seconds
}

function stopReviewTimer() {
    if (reviewInterval) {
        clearInterval(reviewInterval);
    }
}

// Event Listeners for controls
if (nextBtn) {
    nextBtn.addEventListener('click', () => {
        showReview(currentReviewIndex + 1);
        startReviewTimer(); // reset timer on manual click
    });
}

if (prevBtn) {
    prevBtn.addEventListener('click', () => {
        showReview(currentReviewIndex - 1);
        startReviewTimer(); // reset timer on manual click
    });
}

if (reviewDots) {
    reviewDots.forEach(dot => {
        dot.addEventListener('click', (e) => {
            const index = parseInt(e.target.getAttribute('data-index'));
            showReview(index);
            startReviewTimer(); // reset timer on manual click
        });
    });
}

// Initialize reviews slider
if (reviewItems.length > 0) {
    showReview(0);
    startReviewTimer();
}

// Preloader Screen Logic (Fades out after 1 second and reveals Promo Poster if present)
function initPreloader() {
    const preloader = document.getElementById('preloader');
    if (preloader) {
        setTimeout(() => {
            preloader.classList.add('preloader-fade-out');
            
            // Show Promo Modal after preloader fades out
            const promoModal = document.getElementById('promo-modal');
            if (promoModal) {
                setTimeout(openPromoModal, 300);
            } else {
                document.body.classList.remove('no-scroll'); // Re-enable vertical scrolling if no promo modal
            }
        }, 1000); // 1 second duration
    }
}

if (document.readyState === 'loading') {
    window.addEventListener('DOMContentLoaded', initPreloader);
} else {
    initPreloader();
}

// FIFA World Cup Restaurant Feast Click-to-Activate Animation
const soccerCloche = document.getElementById('soccer-cloche');
const feastAltar = document.getElementById('fifa-feast-altar');
if (soccerCloche && feastAltar) {
    soccerCloche.addEventListener('click', () => {
        if (!feastAltar.classList.contains('activated')) {
            feastAltar.classList.add('activated');
            
            // Reset animations after 2.5 seconds
            setTimeout(() => {
                feastAltar.classList.remove('activated');
            }, 2500);
        }
    });
}

// ============================================================
// PROMOTIONAL POSTER MODAL LOGIC
// ============================================================
const promoModal = document.getElementById('promo-modal');
const closePromoModalBtn = document.getElementById('close-promo-modal-btn');
const promoModalOverlay = document.querySelector('.promo-modal-overlay');
const promoModalContent = document.querySelector('.promo-modal-content');
const openPromoModalDirectBtn = document.getElementById('open-promo-modal-direct-btn');

function closePromoModal() {
    if (promoModal && promoModalContent) {
        const button = document.getElementById('open-promo-modal-direct-btn');
        if (button) {
            const buttonRect = button.getBoundingClientRect();
            const contentRect = promoModalContent.getBoundingClientRect();

            // Calculate exact center coordinates difference
            const dx = (buttonRect.left + buttonRect.width / 2) - (contentRect.left + contentRect.width / 2);
            const dy = (buttonRect.top + buttonRect.height / 2) - (contentRect.top + contentRect.height / 2);

            // Apply to CSS variables
            promoModalContent.style.setProperty('--fly-x', `${dx}px`);
            promoModalContent.style.setProperty('--fly-y', `${dy}px`);
        }

        // Add closing state to trigger scale and translation
        promoModal.classList.add('closing');
        document.body.classList.remove('no-scroll'); // Restore scrolling

        setTimeout(() => {
            promoModal.classList.remove('active', 'closing');
            promoModalContent.style.removeProperty('--fly-x');
            promoModalContent.style.removeProperty('--fly-y');
        }, 650);
    } else if (promoModal) {
        promoModal.classList.remove('active');
        document.body.classList.remove('no-scroll');
    }
}

function openPromoModal() {
    if (promoModal) {
        promoModal.classList.remove('closing');
        if (promoModalContent) {
            promoModalContent.style.removeProperty('--fly-x');
            promoModalContent.style.removeProperty('--fly-y');
        }
        promoModal.classList.add('active');
        document.body.classList.add('no-scroll'); // Lock scrolling
    }
}

if (openPromoModalDirectBtn) {
    openPromoModalDirectBtn.addEventListener('click', openPromoModal);
}

if (closePromoModalBtn) {
    closePromoModalBtn.addEventListener('click', closePromoModal);
}

if (promoModalOverlay) {
    promoModalOverlay.addEventListener('click', closePromoModal);
}


