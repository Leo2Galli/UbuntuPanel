import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Container, Row, Col, Button, Form } from 'react-bootstrap';

function App() {
  const [containers, setContainers] = useState([]);
  const [newContainer, setNewContainer] = useState({ image: '', name: '', ports: '' });
  const [translations, setTranslations] = useState({});

  useEffect(() => {
    fetchContainers();
  }, []);

  const fetchContainers = async () => {
    const response = await axios.get('http://localhost:5000/');
    setContainers(response.data.containers);
    setTranslations(response.data.translations);
  };

  const handleStart = async (id) => {
    await axios.post(`http://localhost:5000/start/${id}`);
    fetchContainers();
  };

  const handleStop = async (id) => {
    await axios.post(`http://localhost:5000/stop/${id}`);
    fetchContainers();
  };

  const handleCreate = async (e) => {
    e.preventDefault();
    const ports = newContainer.ports.split(',').reduce((acc, port) => {
      const [hostPort, containerPort] = port.split(':');
      acc[hostPort] = containerPort;
      return acc;
    }, {});
    await axios.post('http://localhost:5000/create', { ...newContainer, ports });
    setNewContainer({ image: '', name: '', ports: '' });
    fetchContainers();
  };

  return (
    <Container>
      <h1 className="text-center my-4">{translations.title}</h1>

      <Row className="my-3">
        {containers.map((container) => (
          <Col md={4} key={container.id} className="mb-4">
            <div className="p-3 border bg-light">
              <h5>{container.name}</h5>
              <p>{translations.status}: {container.status}</p>
              <Button variant="success" onClick={() => handleStart(container.id)}>{translations.start}</Button>
              <Button variant="danger" onClick={() => handleStop(container.id)} className="ml-2">{translations.stop}</Button>
            </div>
          </Col>
        ))}
      </Row>

      <h2>{translations.create_container}</h2>
      <Form onSubmit={handleCreate}>
        <Form.Group>
          <Form.Label>{translations.image}</Form.Label>
          <Form.Control
            type="text"
            value={newContainer.image}
            onChange={(e) => setNewContainer({ ...newContainer, image: e.target.value })}
            placeholder={translations.image}
          />
        </Form.Group>
        <Form.Group>
          <Form.Label>{translations.name}</Form.Label>
          <Form.Control
            type="text"
            value={newContainer.name}
            onChange={(e) => setNewContainer({ ...newContainer, name: e.target.value })}
            placeholder={translations.name}
          />
        </Form.Group>
        <Form.Group>
          <Form.Label>{translations.ports}</Form.Label>
          <Form.Control
            type="text"
            value={newContainer.ports}
            onChange={(e) => setNewContainer({ ...newContainer, ports: e.target.value })}
            placeholder={translations.ports}
          />
        </Form.Group>
        <Button variant="primary" type="submit">{translations.create}</Button>
      </Form>
    </Container>
  );
}

export default App;
