import {
  Body,
  Button,
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

interface SlackForgotPasswordProps {
  name: string;
  resetPasswordLink: string;
}

export const ForgotPassword = ({
  name,
  resetPasswordLink,
}: SlackForgotPasswordProps) => (
  <Html>
    <Head />
    <Preview>Şifreni Sıfırla</Preview>
    <Body style={main}>
      <Container style={container}>
        <Section style={logoContainer}>Logo</Section>
        <Heading style={h1}>Şifreni Sıfırla</Heading>
        <Text style={heroText}>
          Merhaba <strong style={nameText}>{name}</strong>, <br />
          <br />
          Şifrenizi sıfırlama talebinde bulundunuz. Eğer bu talebi siz
          yaptıysanız aşağıdaki linke tıklayarak şifrenizi sıfırlayabilirsiniz.
        </Text>

        <Button style={button} href={resetPasswordLink}>
          Şifreni Sıfırla
        </Button>

        <Text style={text}>
          1 saat içinde şifrenizi sıfırlamazsanız, bu link geçersiz hale
          gelecektir.
        </Text>

        <Hr />

        <Text
          style={{
            ...text,
            fontSize: '12px',
          }}
        >
          Eğer şifrenizi sıfırlama talebinde bulunmadıysanız, bu e-postayı
          dikkate almayınız. Hesabınızın güvende olması için lütfen bu e-postayı
          kimseyle paylaşmayınız.
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

ForgotPassword.PreviewProps = {
  name: 'John Doe',
} as SlackForgotPasswordProps;

export default ForgotPassword;

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

const button = {
  backgroundColor: '#1d1c1d',
  borderRadius: '4px',
  color: '#fff',
  fontFamily: "'Open Sans', 'Helvetica Neue', Arial",
  fontSize: '15px',
  textDecoration: 'none',
  textAlign: 'center' as const,
  display: 'block',
  width: '210px',
  padding: '14px 7px',
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
