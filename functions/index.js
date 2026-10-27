const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getAuth} = require("firebase-admin/auth");
const {
  getFirestore,
  FieldValue,
} = require("firebase-admin/firestore");

initializeApp();

const db = getFirestore();
const auth = getAuth();

// ============================================================
// HELPER
// ============================================================

function cleanString(value) {
  if (value === undefined || value === null) {
    return "";
  }

  return String(value).trim();
}

// ============================================================
// CEK PEMANGGIL
// HANYA GURU YANG BOLEH KELOLA USER
// ============================================================

async function verifyGuru(request) {
  if (!request.auth) {
    throw new HttpsError(
        "unauthenticated",
        "Anda harus login terlebih dahulu.",
    );
  }

  const uid = request.auth.uid;

  const userDoc = await db
      .collection("users")
      .doc(uid)
      .get();

  if (!userDoc.exists) {
    throw new HttpsError(
        "permission-denied",
        "Data pengguna tidak ditemukan.",
    );
  }

  const data = userDoc.data();

  if (!data || data.role !== "guru") {
    throw new HttpsError(
        "permission-denied",
        "Hanya guru yang dapat mengelola user.",
    );
  }

  return uid;
}

// ============================================================
// CREATE USER
// ============================================================

exports.createUser = onCall(async (request) => {
  await verifyGuru(request);

  const data = request.data || {};

  const nama = cleanString(data.nama);
  const email = cleanString(data.email).toLowerCase();
  const password = cleanString(data.password);
  const role = cleanString(data.role);

  const nip = cleanString(data.nip);
  const sekolah = cleanString(data.sekolah);
  const mataPelajaran = cleanString(data.mataPelajaran);
  const nomorHp = cleanString(data.nomorHp);
  const bio = cleanString(data.bio);

  // ----------------------------------------------------------
  // VALIDASI
  // ----------------------------------------------------------

  if (!nama || !email || !password || !role) {
    throw new HttpsError(
        "invalid-argument",
        "Nama, email, password, dan role wajib diisi.",
    );
  }

  if (role !== "guru" && role !== "siswa") {
    throw new HttpsError(
        "invalid-argument",
        "Role hanya boleh guru atau siswa.",
    );
  }

  if (password.length < 6) {
    throw new HttpsError(
        "invalid-argument",
        "Password minimal 6 karakter.",
    );
  }

  try {
    // --------------------------------------------------------
    // BUAT FIREBASE AUTH
    // --------------------------------------------------------

    const userRecord = await auth.createUser({
      email: email,
      password: password,
      displayName: nama,
    });

    // --------------------------------------------------------
    // SIMPAN FIRESTORE
    // --------------------------------------------------------

    await db
        .collection("users")
        .doc(userRecord.uid)
        .set({
          uid: userRecord.uid,
          nama: nama,
          email: email,
          role: role,
          nip: nip,
          sekolah: sekolah,
          mataPelajaran: mataPelajaran,
          nomorHp: nomorHp,
          bio: bio,
          createdAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
        });

    return {
      success: true,
      uid: userRecord.uid,
      message: "User berhasil dibuat.",
    };
  } catch (error) {
    console.error("createUser error:", error);

    if (error.code === "auth/email-already-exists") {
      throw new HttpsError(
          "already-exists",
          "Email tersebut sudah digunakan.",
      );
    }

    if (error.code === "auth/invalid-email") {
      throw new HttpsError(
          "invalid-argument",
          "Format email tidak valid.",
      );
    }

    if (error.code === "auth/weak-password") {
      throw new HttpsError(
          "invalid-argument",
          "Password terlalu lemah.",
      );
    }

    throw new HttpsError(
        "internal",
        "Gagal membuat user.",
    );
  }
});

// ============================================================
// UPDATE USER
// ============================================================

exports.updateUser = onCall(async (request) => {
  await verifyGuru(request);

  const data = request.data || {};

  const uid = cleanString(data.uid);

  if (!uid) {
    throw new HttpsError(
        "invalid-argument",
        "UID user wajib diberikan.",
    );
  }

  const nama = cleanString(data.nama);
  const email = cleanString(data.email).toLowerCase();
  const password = cleanString(data.password);
  const role = cleanString(data.role);

  const nip = cleanString(data.nip);
  const sekolah = cleanString(data.sekolah);
  const mataPelajaran = cleanString(data.mataPelajaran);
  const nomorHp = cleanString(data.nomorHp);
  const bio = cleanString(data.bio);

  // ----------------------------------------------------------
  // VALIDASI
  // ----------------------------------------------------------

  if (!role) {
    throw new HttpsError(
        "invalid-argument",
        "Role wajib dipilih.",
    );
  }

  if (role !== "guru" && role !== "siswa") {
    throw new HttpsError(
        "invalid-argument",
        "Role hanya boleh guru atau siswa.",
    );
  }

  if (password && password.length < 6) {
    throw new HttpsError(
        "invalid-argument",
        "Password minimal 6 karakter.",
    );
  }

  try {
    // --------------------------------------------------------
    // CEK USER AUTH
    // --------------------------------------------------------

    await auth.getUser(uid);

    // --------------------------------------------------------
    // UPDATE FIREBASE AUTH
    // --------------------------------------------------------

    const authUpdate = {};

    if (nama) {
      authUpdate.displayName = nama;
    }

    if (email) {
      authUpdate.email = email;
    }

    if (password) {
      authUpdate.password = password;
    }

    if (Object.keys(authUpdate).length > 0) {
      await auth.updateUser(uid, authUpdate);
    }

    // --------------------------------------------------------
    // UPDATE FIRESTORE
    // --------------------------------------------------------

    await db
        .collection("users")
        .doc(uid)
        .set(
            {
              uid: uid,
              nama: nama,
              email: email,
              role: role,
              nip: nip,
              sekolah: sekolah,
              mataPelajaran: mataPelajaran,
              nomorHp: nomorHp,
              bio: bio,
              updatedAt: FieldValue.serverTimestamp(),
            },
            {
              merge: true,
            },
        );

    return {
      success: true,
      message: "User berhasil diperbarui.",
    };
  } catch (error) {
    console.error("updateUser error:", error);

    if (error.code === "auth/user-not-found") {
      throw new HttpsError(
          "not-found",
          "User tidak ditemukan.",
      );
    }

    if (error.code === "auth/email-already-exists") {
      throw new HttpsError(
          "already-exists",
          "Email tersebut sudah digunakan.",
      );
    }

    if (error.code === "auth/invalid-email") {
      throw new HttpsError(
          "invalid-argument",
          "Format email tidak valid.",
      );
    }

    throw new HttpsError(
        "internal",
        "Gagal memperbarui user.",
    );
  }
});

// ============================================================
// DELETE USER
// ============================================================

exports.deleteUser = onCall(async (request) => {
  const callerUid = await verifyGuru(request);

  const data = request.data || {};
  const uid = cleanString(data.uid);

  if (!uid) {
    throw new HttpsError(
        "invalid-argument",
        "UID user wajib diberikan.",
    );
  }

  // ----------------------------------------------------------
  // JANGAN HAPUS AKUN SENDIRI
  // ----------------------------------------------------------

  if (uid === callerUid) {
    throw new HttpsError(
        "failed-precondition",
        "Anda tidak dapat menghapus akun sendiri.",
    );
  }

  try {
    // --------------------------------------------------------
    // HAPUS FIREBASE AUTH
    // --------------------------------------------------------

    await auth.deleteUser(uid);

    // --------------------------------------------------------
    // HAPUS FIRESTORE
    // --------------------------------------------------------

    await db
        .collection("users")
        .doc(uid)
        .delete();

    return {
      success: true,
      message: "User berhasil dihapus.",
    };
  } catch (error) {
    console.error("deleteUser error:", error);

    // Jika Auth sudah tidak ada,
    // tetap bersihkan Firestore.
    if (error.code === "auth/user-not-found") {
      await db
          .collection("users")
          .doc(uid)
          .delete();

      return {
        success: true,
        message: "Data user berhasil dibersihkan.",
      };
    }

    throw new HttpsError(
        "internal",
        "Gagal menghapus user.",
    );
  }
});

// ============================================================
// GET USERS
// ============================================================

exports.getUsers = onCall(async (request) => {
  await verifyGuru(request);

  try {
    const snapshot = await db
        .collection("users")
        .orderBy("nama")
        .get();

    const users = snapshot.docs.map((doc) => {
      const data = doc.data();

      return {
        uid: doc.id,
        nama: cleanString(data.nama),
        email: cleanString(data.email),
        role: cleanString(data.role),
        nip: cleanString(data.nip),
        sekolah: cleanString(data.sekolah),
        mataPelajaran: cleanString(
            data.mataPelajaran,
        ),
        nomorHp: cleanString(data.nomorHp),
        bio: cleanString(data.bio),
      };
    });

    return {
      success: true,
      users: users,
    };
  } catch (error) {
    console.error("getUsers error:", error);

    throw new HttpsError(
        "internal",
        "Gagal mengambil data user.",
    );
  }
});
