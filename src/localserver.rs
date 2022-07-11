use std::fs;
use std::path::Path;
use tokio::runtime::Runtime;
use tokio::sync::{
    oneshot,
    oneshot::{Receiver, Sender},
};


pub struct LocalServer {
    path: String,
    port: u16,
    tx: Option<Sender<()>>,
}


impl LocalServer {
    pub fn create(path: String, port: u16) -> anyhow::Result<LocalServer> {
        Ok(LocalServer {
            path,
            port,
            tx: None,
        })
    }

    pub fn start(&mut self)->anyhow::Result<()> {
        let (tx, rx) = oneshot::channel();
        self.tx = Some(tx);
        let path = self.path.clone();
        let port = self.port;
        let rt = Runtime::new()?;
        rt.block_on(run_server(&path, port, rx))?;
        Ok(())
    }

    pub fn stop(self) {
        if let Some(tx) = self.tx {
            let _ = tx.send(());
        }
    }
}

async fn run_server(path: &str, port: u16, rx: Receiver<()>) -> anyhow::Result<()> {
    let path = Path::new(path);
    let abs_path = fs::canonicalize(path)?;
    let (_, server) = warp::serve(warp::fs::dir(abs_path))
        .try_bind_with_graceful_shutdown(([127, 0, 0, 1], port), async move {
            println!("waiting for signal");
            rx.await.ok();
            println!("done waiting for signal");
        })?;
    server.await;
    Ok(())
}


#[cfg(test)]
mod tests {
    use std::thread;
    use std::time::Duration;
    use crate::localserver::LocalServer;

    #[test]
    fn localserver_works() -> anyhow::Result<()> {
        let mut localserver = LocalServer::create("/Users/icekylin/Documents/Projects/WorkSource/m-survey-plus/dist/".to_string(), 3216)?;
        let _ = localserver.start();
        println!("server started");
        thread::sleep(Duration::from_secs(1));
        println!("server try stop");
        localserver.stop();
        println!("server stopped");
        thread::sleep(Duration::from_secs(1));
        Ok(())
    }
}