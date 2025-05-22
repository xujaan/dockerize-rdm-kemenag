Aplikasi RDM Kemenag
# dockerize-rdm-kemenag


## Petunjuk Instalasi

### Persyaratan
- Docker CLI: Pastikan Anda telah menginstal Docker di sistem Anda. Anda dapat mengikuti panduan instalasi [di sini](https://docs.docker.com/get-docker/).

### Langkah-langkah Instalasi

1. **Clone Repository**
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Edit Konfigurasi**
   - Buka file `config.php` yang terletak di direktori root proyek.
   - Sesuaikan konfigurasi database sesuai dengan pengaturan Anda:
     ```php
     $host = "host_database_anda";
     $databaseuser = "user_database_anda";
     $databasename = "nama_database_anda";
     $dbpassword = "password_database_anda";
     ```
    - Import database.sql di database engine Anda, jika Anda menginstall RDM dari awal atau kosongan.

3. **Atur Izin untuk Sessions**
   - Jalankan perintah berikut untuk mengatur izin yang diperlukan untuk direktori session:
     ```bash
     sudo chmod 777 -R system/sessions
     ```

4. **Build dan Jalankan dengan Docker**
   - Gunakan Docker untuk build dan menjalankan aplikasi. Pastikan Anda memiliki `Dockerfile` dan `docker-compose.yml` jika diperlukan, dan jalankan:
     ```bash
     docker-compose up --build
     ```



