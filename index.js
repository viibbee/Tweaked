
const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { signIPA } = require('./signer');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, '../frontend')));

const upload = multer({ dest: 'uploads/' });

app.post('/sign', upload.fields([
  { name: 'ipa' }, { name: 'p12' }, { name: 'mobileprovision' }
]), async (req, res) => {
  try {
    const ipa = req.files['ipa'][0].path;
    const p12 = req.files['p12'][0].path;
    const mp = req.files['mobileprovision'][0].path;

    const signedPath = await signIPA(ipa, p12, mp);

    const plistUrl = `${req.protocol}://${req.get('host')}/plist/${path.basename(signedPath, '.ipa')}.plist`;
    res.json({ installUrl: `itms-services://?action=download-manifest&url=${plistUrl}` });
  } catch (err) {
    res.status(500).json({ error: 'Failed to sign IPA' });
  }
});

app.get('/plist/:id', (req, res) => {
  const id = req.params.id;
  const plist = fs.readFileSync(path.join(__dirname, '../manifest/template.plist'), 'utf8');
  const result = plist.replace('{{IPA_URL}}', `https://${req.get('host')}/uploads/${id}.ipa`);
  res.type('application/xml').send(result);
});

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
