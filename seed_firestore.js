const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Load service account key (download from Firebase Console)
const serviceAccountPath = path.join(__dirname, 'firebase-key.json');

if (!fs.existsSync(serviceAccountPath)) {
  console.error('❌ firebase-key.json nem található!');
  console.error('Letöltés: Firebase Console > Projekt beállításai > Szolgáltatási fiók > Admin SDK > Új privát kulcs generálása');
  process.exit(1);
}

const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id,
});

const db = admin.firestore();

async function seedDatabase() {
  try {
    console.log('🌱 BookNails Firestore seed adatok feltöltése...\n');

    // 1. KATEGÓRIÁK feltöltése
    console.log('📁 Kategóriák létrehozása...');
    const categories = [
      { name: 'French Manicure', type: 'service' },
      { name: 'Gel Manicure', type: 'service' },
      { name: 'Pedicure', type: 'service' },
      { name: 'Nail Art', type: 'service' },
      { name: 'Akril Körmök', type: 'service' },
    ];

    const categoryIds = {};
    for (const cat of categories) {
      const docRef = await db.collection('categories').add({
        name: cat.name,
        type: cat.type,
        createdAt: admin.firestore.Timestamp.now(),
        updatedAt: admin.firestore.Timestamp.now(),
      });
      categoryIds[cat.name] = docRef.id;
      console.log(`  ✅ ${cat.name} (ID: ${docRef.id})`);
    }

    // 2. NAIL ARTIST FELHASZNÁLÓ ÉS PROFIL feltöltése
    console.log('\n👩‍💼 Nail Artist feltöltése...');

    // Nail artist user
    const nailArtistRef = await db.collection('users').doc('nail_artist_demo_001').set({
      name: 'Hajnalka Kozmetikus',
      email: 'hajnalka@nails.com',
      role: 'nail_artist',
      phoneNumber: '+36 30 123 4567',
      createdAt: admin.firestore.Timestamp.now(),
      updatedAt: admin.firestore.Timestamp.now(),
    });
    console.log(`  ✅ User: Hajnalka Kozmetikus`);

    // Nail artist profile
    const profileRef = await db.collection('nail_artist_profiles').add({
      userId: 'nail_artist_demo_001',
      salonName: 'Luxe Nail Studio Budapest',
      address: '1051 Budapest, Nádor utca 12.',
      phoneNumber: '+36 1 266 5678',
      profileImageUrl: null,
      workingHours: {
        monday: { start: '09:00', end: '18:00' },
        tuesday: { start: '09:00', end: '18:00' },
        wednesday: { start: '09:00', end: '18:00' },
        thursday: { start: '09:00', end: '20:00' },
        friday: { start: '09:00', end: '20:00' },
        saturday: { start: '10:00', end: '16:00' },
        sunday: { start: 'closed', end: 'closed' },
      },
      rating: 4.8,
      reviewCount: 25,
      createdAt: admin.firestore.Timestamp.now(),
      updatedAt: admin.firestore.Timestamp.now(),
    });
    const profileId = profileRef.id;
    console.log(`  ✅ Profile: Luxe Nail Studio Budapest (ID: ${profileId})`);

    // 3. RENDSZERES FELHASZNÁLÓK feltöltése
    console.log('\n👥 Rendszeres felhasználók feltöltése...');
    const regularUsers = [
      {
        id: 'user_demo_001',
        name: 'Kiss Katalin',
        email: 'katalin.demo@example.com',
        role: 'user',
        phoneNumber: '+36 30 987 6543',
      },
      {
        id: 'user_demo_002',
        name: 'Nagy Éva',
        email: 'eva.demo@example.com',
        role: 'user',
        phoneNumber: '+36 30 555 6789',
      },
      {
        id: 'user_demo_003',
        name: 'Horváth Krisztina',
        email: 'krisztina.demo@example.com',
        role: 'user',
        phoneNumber: '+36 30 666 7890',
      },
    ];

    const userIds = [];
    for (const user of regularUsers) {
      await db.collection('users').doc(user.id).set({
        name: user.name,
        email: user.email,
        role: user.role,
        phoneNumber: user.phoneNumber,
        createdAt: admin.firestore.Timestamp.now(),
        updatedAt: admin.firestore.Timestamp.now(),
      });
      userIds.push(user.id);
      console.log(`  ✅ ${user.name} (${user.email})`);
    }

    // 4. SZOLGÁLTATÁSOK feltöltése
    console.log('\n💅 Szolgáltatások feltöltése...');
    const services = [
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['French Manicure'],
        name: 'Prémium French Manicure',
        description: 'Professzionális francia manikűr gél lakkal, hosszú tartósság.',
        price: 8500.0,
        durationMinutes: 60,
        imageUrl: null,
        isActive: true,
      },
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['Gel Manicure'],
        name: 'Gel Manicure Standard',
        description: 'UV-s gél manikűr alapszínekben.',
        price: 7500.0,
        durationMinutes: 50,
        imageUrl: null,
        isActive: true,
      },
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['Pedicure'],
        name: 'Luxe Pedicure',
        description: 'Komplett pedikűr masszázzsal és spa kezeléssel.',
        price: 9500.0,
        durationMinutes: 90,
        imageUrl: null,
        isActive: true,
      },
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['Nail Art'],
        name: 'Nail Art Deluxe',
        description: 'Egyedi körmök festéssel és dekorációval.',
        price: 12000.0,
        durationMinutes: 120,
        imageUrl: null,
        isActive: true,
      },
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['Akril Körmök'],
        name: 'Akril Körmök Építés',
        description: 'Akril körmök építése és formázása.',
        price: 10000.0,
        durationMinutes: 90,
        imageUrl: null,
        isActive: true,
      },
    ];

    const serviceIds = [];
    for (const service of services) {
      const docRef = await db.collection('services').add({
        ...service,
        createdAt: admin.firestore.Timestamp.now(),
        updatedAt: admin.firestore.Timestamp.now(),
      });
      serviceIds.push(docRef.id);
      console.log(`  ✅ ${service.name} - ${service.price} Ft (ID: ${docRef.id})`);
    }

    // 5. FOGLALÁSOK feltöltése
    console.log('\n📅 Foglalások létrehozása...');
    const now = new Date();
    const appointments = [
      {
        userId: userIds[0],
        nailArtistProfileId: profileId,
        serviceId: serviceIds[0],
        appointmentDate: new Date(now.getTime() + 24 * 60 * 60 * 1000), // holnap
        startTime: '14:00',
        requestedDurationMinutes: 60,
        estimatedDurationMinutes: null,
        note: 'Kérem a természetes színt!',
        status: 'pending',
      },
      {
        userId: userIds[1],
        nailArtistProfileId: profileId,
        serviceId: serviceIds[1],
        appointmentDate: new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000), // 2 nap
        startTime: '10:00',
        requestedDurationMinutes: 50,
        estimatedDurationMinutes: null,
        note: '',
        status: 'pending',
      },
      {
        userId: userIds[2],
        nailArtistProfileId: profileId,
        serviceId: serviceIds[2],
        appointmentDate: new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000), // 3 nap
        startTime: '15:30',
        requestedDurationMinutes: 90,
        estimatedDurationMinutes: null,
        note: 'Spá paket kérem',
        status: 'confirmed',
      },
      {
        userId: userIds[0],
        nailArtistProfileId: profileId,
        serviceId: serviceIds[3],
        appointmentDate: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000), // 7 napja
        startTime: '11:00',
        requestedDurationMinutes: 120,
        estimatedDurationMinutes: 120,
        note: 'Csillámok nélkül',
        status: 'completed',
      },
    ];

    const appointmentIds = [];
    for (const apt of appointments) {
      const docRef = await db.collection('appointments').add({
        ...apt,
        appointmentDate: admin.firestore.Timestamp.fromDate(apt.appointmentDate),
        createdAt: admin.firestore.Timestamp.now(),
        updatedAt: admin.firestore.Timestamp.now(),
      });
      appointmentIds.push(docRef.id);
      console.log(`  ✅ Foglalás #${appointmentIds.length} - ${apt.status} (ID: ${docRef.id})`);
    }

    // 6. GALÉRIA TÉTELEK feltöltése
    console.log('\n🖼️  Galéria tételek feltöltése...');
    const galleryItems = [
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['French Manicure'],
        imageUrl: null,
        title: 'Ombre French Nails',
        description: 'Gyönyörű ombre effekt francesa manikűrrel',
      },
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['Nail Art'],
        imageUrl: null,
        title: 'Spring Collection Nails',
        description: 'Tavasz inspirálta virág motívumok',
      },
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['Gel Manicure'],
        imageUrl: null,
        title: 'Sparkly Gel Design',
        description: 'Csillogó gél manikűr és csillámozás',
      },
      {
        nailArtistProfileId: profileId,
        categoryId: categoryIds['Akril Körmök'],
        imageUrl: null,
        title: 'Luxury Acrylic Set',
        description: 'Prémium akril körmök hosszabb tartóssággal',
      },
    ];

    for (const item of galleryItems) {
      const docRef = await db.collection('gallery_items').add({
        ...item,
        createdAt: admin.firestore.Timestamp.now(),
      });
      console.log(`  ✅ ${item.title} (ID: ${docRef.id})`);
    }

    console.log('\n✅ Firestore seed adatok sikeresen feltöltve!\n');
    console.log(`
📊 ÖSSZEFOGLALÁS:
  ✨ Kategóriák: ${Object.keys(categoryIds).length}
  💅 Nail Artist: 1
  👥 Rendszeres felhasználók: ${userIds.length}
  💼 Szolgáltatások: ${serviceIds.length}
  📅 Foglalások: ${appointmentIds.length}
  🖼️  Galéria tételek: ${galleryItems.length}

🔑 DEMO ADATOK:
  Email: hajnalka@nails.com (Nail Artist)
  Email: katalin.demo@example.com (Felhasználó 1)
  Email: eva.demo@example.com (Felhasználó 2)
  Email: krisztina.demo@example.com (Felhasználó 3)

💡 A Firestore-ban most már elérhető az összes teszt adat!
    `);

    process.exit(0);
  } catch (error) {
    console.error('❌ Hiba a seed adatok feltöltésekor:', error);
    process.exit(1);
  }
}

seedDatabase();

