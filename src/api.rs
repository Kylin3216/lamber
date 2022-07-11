use std::{fs, io};
use crate::localserver::LocalServer;

pub fn unzip(path: String) -> anyhow::Result<()> {
    let name = std::path::Path::new(&path);
    let file = fs::File::open(&name)?;
    let dir = name.parent().unwrap();
    let mut archive = zip::ZipArchive::new(file)?;
    for i in 0..archive.len() {
        let mut file = archive.by_index(i)?;
        let out_path = match file.enclosed_name() {
            Some(path) => dir.join(path.to_owned()),
            None => continue,
        };

        {
            let comment = file.comment();
            if !comment.is_empty() {
                println!("File {} comment: {}", i, comment);
            }
        }

        if (*file.name()).ends_with('/') {
            println!("File {} extracted to \"{}\"", i, out_path.display());
            fs::create_dir_all(&out_path)?;
        } else {
            println!(
                "File {} extracted to \"{}\" ({} bytes)",
                i,
                out_path.display(),
                file.size()
            );
            if let Some(p) = out_path.parent() {
                if !p.exists() {
                    fs::create_dir_all(&p)?;
                }
            }
            let mut outfile = fs::File::create(&out_path)?;
            io::copy(&mut file, &mut outfile)?;
        }

        // Get and Set permissions
        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt;
            if let Some(mode) = file.unix_mode() {
                fs::set_permissions(&out_path, fs::Permissions::from_mode(mode))?;
            }
        }
    }
    Ok(())
}

pub fn create_local_server(path: String, port: u16) -> anyhow::Result<usize> {
    let server = LocalServer::create(path, port)?;
    Ok(Box::into_raw(Box::new(server)) as usize)
}

pub fn start_local_server(pointer: usize) {
    let server_pointer = pointer as *mut LocalServer;
    println!("try start_local_server!!!!{}",pointer);
    if !server_pointer.is_null() {
        println!("start_local_server!!!!");
        let server = unsafe { &mut *server_pointer };
        server.start().expect("TODO: panic message");
    }
}

pub fn stop_local_server(pointer: usize) {
    let server_pointer = pointer as *mut LocalServer;
    println!("try stop_local_server!!!!{}",pointer);
    if !server_pointer.is_null() {
        println!("stop_local_server!!!!");
        let server = unsafe { Box::from_raw(server_pointer) };
        server.stop();
    }
}
