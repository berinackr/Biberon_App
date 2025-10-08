import {
  Body,
  Container,
  Head,
  Heading,
  Hr,
  Html,
  Link,
  Preview,
  Section,
  Text,
} from '@react-email/components';
import * as React from 'react';

interface SlackConfirmEmailProps {
  name: string;
  validationCode: string;
}

export const ConfirmEmail = ({
  name,
  validationCode,
}: SlackConfirmEmailProps) => (
  <Html>
    <Head />
    <Preview>Email adresini doğrula</Preview>
    <Body style={main}>
      <Container style={container}>
        <Section style={logoContainer}>Logo</Section>
        <Heading style={h1}>Email adresini doğrula</Heading>
        <Text style={heroText}>
          Merhaba <strong style={nameText}>{name}</strong>, <br />
          <br />
          Uygulamamıza üye olduğunuz için teşekkür ederiz. Hesabınızı
          kullanabilmek için emailinizi doğrulamalısınız. Aşağıdaki kodu
          uygulamamızda ilgili yere girerek hesabınızı doğrulayabilirsiniz.
        </Text>

        <Section style={codeBox}>
          <Text style={confirmationCodeText}>{validationCode}</Text>
        </Section>

        <Text style={text}>
          24 saat içinde doğrulama işlemini gerçekleştirmezseniz, bu kod
          geçersiz hale gelecektir.
        </Text>

        <Hr />

        <Text
          style={{
            ...text,
            fontSize: '12px',
          }}
        >
          Bu e-posta, Biberon Uygulaması tarafından gönderilmiştir. Eğer
          uygulamamıza üye olmadıysanız, bu e-postayı dikkate almayınız.
        </Text>

        <Section>
          <Link
            style={footerLink}
            href=""
            target="_blank"
            rel="noopener noreferrer"
          >
            Websitemiz
          </Link>
          &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
          <Link
            style={footerLink}
            href=""
            target="_blank"
            rel="noopener noreferrer"
          >
            Politikalarımız
          </Link>
          &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
          <Link
            style={footerLink}
            href=""
            target="_blank"
            rel="noopener noreferrer"
          >
            Yardım Merkezi
          </Link>
          &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
          <Link
            style={footerLink}
            href=""
            target="_blank"
            rel="noopener noreferrer"
            data-auth="NotApplicable"
            data-linkindex="6"
          >
            Hakkımızda
          </Link>
          <Text style={footerText}>
            Biberon App <br />
            Tüm hakları saklıdır.
          </Text>
        </Section>
      </Container>
    </Body>
  </Html>
);

ConfirmEmail.PreviewProps = {
  name: 'John Doe',
} as SlackConfirmEmailProps;

export default ConfirmEmail;

const footerText = {
  fontSize: '12px',
  color: '#b7b7b7',
  lineHeight: '15px',
  textAlign: 'left' as const,
  marginBottom: '50px',
};

const nameText = {
  color: '#4a4a4a',
};

const footerLink = {
  color: '#b7b7b7',
  textDecoration: 'underline',
};

const main = {
  backgroundColor: '#ffffff',
  margin: '0 auto',
  fontFamily:
    "-apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif",
};

const container = {
  margin: '0 auto',
  padding: '0px 20px',
};

const logoContainer = {
  marginTop: '32px',
};

const h1 = {
  color: '#1d1c1d',
  fontSize: '36px',
  fontWeight: '700',
  margin: '30px 0',
  padding: '0',
  lineHeight: '42px',
};

const heroText = {
  fontSize: '16px',
  lineHeight: '24px',
  marginBottom: '20px',
};

const text = {
  color: '#000',
  fontSize: '14px',
  lineHeight: '24px',
};

const codeBox = {
  background: 'rgb(245, 244, 245)',
  borderRadius: '4px',
  marginBottom: '30px',
  padding: '40px 10px',
};

const confirmationCodeText = {
  fontSize: '30px',
  textAlign: 'center' as const,
  verticalAlign: 'middle',
};
